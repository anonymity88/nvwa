# -*- coding: utf-8 -*-

import random
import datetime
import subprocess
import sys
import json
from time import time
import random
from random import randint
import os
import numpy as np
import re
import signal  
import time

sys.path.append('../')
sys.path.append('./')
sys.path.append('/home/llm/generate')

from utils.config import Config
from utils import *
from utils.dbutils import myDB
from utils.logger_tool import log
from utils.IR_analyzer import *
from fuzz.pass_enum import *

from fuzz.reporter import *
from GPT_mutate import MLIRMutator





class Fuzz:
    def __init__(self, config: Config,reporter: Reporter, sqlname):
        self.config = config
        self.reporter = reporter
        self.sqlname = sqlname

    def update_nindex(self, sid, reset=False):
        if reset:
            sql = "update " + self.config.seed_pool_table + " set n = 0 where sid = '%s'" % sid
            dbutils.db.executeSQL(sql)
        else:
            sql = "update " + self.config.seed_pool_table + " set n = n +1 where sid = '%s'" % sid
            dbutils.db.executeSQL(sql)

    def analysis_and_save_seed(self,record_model,output_file):
        sid = record_model.sid
        phase = record_model.phase

        with open(output_file, 'r', encoding='utf-8', errors='replace') as f:
            trans_mlir = f.read()


        ops = IRAnalysis(trans_mlir)
        candidate_lower_pass = ""
        try:
            sql = "insert into " + self.config.seed_pool_table + \
                  " (preid,source,operation, content,n, candidate_lower_pass) " \
                  "values ('%s','%s','%s','%s','%s','%s')" \
                  % \
                  (sid,phase,ops,trans_mlir, 0, candidate_lower_pass)
            dbutils.db.executeSQL(sql)
            self.update_nindex(sid)
            # log.info("======save the result as seed")
        except Exception as e:
            log.error('sql error', e)

    def FuzzingSave(self,record_model):
        sid =record_model.sid
        passes = record_model.passes.replace("'", "")
        returncode = record_model.returncode
        stderr = record_model.stderr.replace("'", "")
        mlir = record_model.mlir
        phase = record_model.phase
        time = record_model.time
        duration = record_model.duration

        ops = IRAnalysis(mlir)

        try:
            sql = "insert into  " + self.config.result_table + \
                  " (sid, content,phase,operation,passes,returnCode,stdout,stderr,duration,datetime) " \
                  "values ('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')" \
                  % \
                  (sid, mlir, phase,ops, passes, returncode, "", stderr, duration, time)
            # log.info(sql)
            dbutils.db.executeSQL(sql)
            # log.info("======save result")
        except Exception as e:
            log.error('sql error', e)

    def bugReport(self,record_model):
        passes = record_model.passes
        returncode = record_model.returncode
        stderr = record_model.stderr.replace("'", "")
        mlir = record_model.mlir
        phase = record_model.phase
        time = record_model.time


        bug_info = self.reporter.getCrashInfo(stderr)

        # 2.1 已保存的bug,不再保存
        if bug_info in self.config.bugs_info:
            print("It's not a new bug!")
        else:
            # TODO 识别该bug是否为未曾报告的bug  new=1表示新的bug
            # new = Fuzz.isNew(self, error, conf)
            # 2.2 保存bug到report_table以及self.config.bugs_info
            try:
                sql = "insert into " + self.config.report_table + \
                      " (new,stack,phase,datetime,stderr,returnCode,mlirContent,passes) " \
                      " values('%s','%s','%s','%s','%s','%s','%s','%s')" \
                      % \
                      (0, bug_info, phase, time, stderr.replace("'", "\'"), returncode, mlir, passes)
                # log.info("===== sql: " + str(sql) )
                dbutils.db.executeSQL(sql)
                self.config.bugs_info.append(bug_info)
            except Exception as e:
              log.error('sql error', e)

    def fixlowerpass(self,singlePass):
        segs = singlePass.split(" -")
        if len(segs)==1: # pass数量==1 且包含-pass-pipeline
            return singlePass

        pass_str = singlePass.replace(" -pass-pipeline", " --pass-pipeline")

        insert = " | " + self.config.mlir_opt
        if "-pass-pipeline" not in segs[0]:
            pass_str = pass_str.replace(" --pass-pipeline", insert + " --pass-pipeline")

        pass_list = []
        for pass_ in pass_str.split(insert):
            # print(pass_)
            pass_ = pass_.lstrip()
            if "pass-pipeline" in pass_ and " -" in pass_:
                first_dash_index = pass_.find(' -')

                # 如果找到了'-'，就在它前面插入'mlir-opt'
                if first_dash_index != -1:
                    modified_string = pass_[:first_dash_index] + insert+ " " + pass_[first_dash_index:]
                pass_ = modified_string

            pass_list.append(pass_)
            i_str = insert +" "
        return i_str.join(pass_list)

    def runMLIR(cmd):
        pro = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8",preexec_fn=os.setsid)
        try:
            stdout, stderr = pro.communicate(timeout=30)
            # log.info(cmd)
            # log.info(stderr)
            return_code = pro.returncode
        except subprocess.TimeoutExpired:
            # pro.kill()
            os.killpg(pro.pid,signal.SIGTERM)
            stdout = ""
            stderr = "timeout, kill this process"
            return_code = 99
        except UnicodeDecodeError:
            stderr = "UnicodeDecodeError: 'utf-8' codec can't decode byte 0x8b in position 3860: invalid start byte"
            return_code = 88
            #0 正常执行
            #1 error
            #134 断言错误

            #139 段错误
            #148 超时
        return return_code,stderr

    def MLIRTest(self,sid,mlir_content,seed_file, output_file,pass_str,phase):
        # pass_str = ' '.join(pass_)
        self.config.Iter += 1
        if "-pass-pipeline" in pass_str:
            pass_str = self.fixlowerpass(pass_str)

        cmd = "{} {} {} -o {}".format(self.config.mlir_opt, seed_file, pass_str, output_file)
        # print(cmd)

        #testing
        start_time = int(time.time() * 1000)
        returncode,stderr = Fuzz.runMLIR(cmd)
        end_time = int(time.time() * 1000)
        duration = int(round(end_time - start_time))

        log.info("#Testing :" + str(self.config.Iter) + "  #Bugs :" + str(len(self.config.bugs_info)) + "  Phase: " + phase ) #+ " pass_str: " + pass_str

        # 保存测试记录
        now = datetime.datetime.strftime(datetime.datetime.now(), '%Y-%m-%d %H:%M:%S')
        record_model = recordObject(sid=sid,returncode=returncode, passes=pass_str, stderr=stderr,
                                    mlir=mlir_content, phase=phase,time=now,duration=duration)

        self.FuzzingSave(record_model)
        if returncode == 0 and os.path.isfile(output_file):   # 保存新种子
            diff = "diff {} {} > /dev/null 2>&1".format(seed_file, output_file)
            result = os.system(diff)
            if result != 0 :  #result == 0 两个文件内容相同。
                self.analysis_and_save_seed(record_model,output_file)
        elif returncode > 130 or returncode == -6:  # 将bug存入数据库
            self.bugReport(record_model)
            #TODO:deal with time out
        # elif returncode == 99:


    # 从数据库种子池选择一个种子
    # 从所有从 n < Nmax 的记录中，随机挑选Num 条，目前Nmax为1，即每个种子最多被选到一次
    def select_seed(self,Nmax,Num):
        sql = "select * from " + self.config.seed_pool_table + " where n < '%s'" % Nmax + "ORDER BY rand() limit %s"  % Num
        seed_types = dbutils.db.queryAll(sql)
        return seed_types  # 一行数据

    def select_target_seed(self,Nmax,dia,Num):
        sql = "select * from " + self.config.seed_pool_table + " where n < '%s' and operation like '%%" % Nmax + dia + "%%' ORDER BY rand() limit %s" % Num
        seed_types = dbutils.db.queryAll(sql)
        return seed_types  # 一行数据

    def process(self,Mut,fuzz_mode):
        conf = self.config
        seed_file = conf.temp_dir + "seed" + ".mlir"

        if not os.path.exists(seed_file):
            os.system(r"touch {}".format(seed_file))

        output_file = conf.temp_dir + "output" + ".mlir"
        output1_file = conf.temp_dir + "lower" + ".mlir"
        output2_file = conf.temp_dir + "mutate" + ".mlir"

        if (fuzz_mode == "P"):
            # lowering
            # affine
            # tosa
            # async
            # scf
            # linalg
            # gpu
            # memref
            # bufferization
            # vector
            # spirv
            # tensor
            proi_lower = [["tosa", "linalg", [
                "-tosa-optional-decompositions -pass-pipeline=\"builtin.module(func.func(tosa-to-linalg-named))\""]],
                          ["tosa", "linalg", ["-tosa-optional-decompositions -pass-pipeline=\"builtin.module(func.func(tosa-to-linalg-named,tosa-to-linalg))\""]],
                          ["tosa", "linalg", ["-tosa-optional-decompositions -tosa-to-tensor",
                              "-tosa-optional-decompositions -tosa-to-scf"]],
                          ["linalg", "affine", ["-linalg-bufferize -convert-linalg-to-parallel-loops"]],
                          ["linalg", "affine", ["-linalg-bufferize -convert-linalg-to-affine-loops"]],
                          ["linalg", "affine", ["-linalg-bufferize -convert-linalg-to-loops"]],
                          ["affine.for", "scf", ["-affine-parallelize"]],
                          ["affine", "scf", ["-lower-affine",
                                             "-affine-super-vectorize=\"virtual-vector-size=128 test-fastest-varying=0 vectorize-reductions=true\""]],
                          ["vector", "scf", ["-convert-vector-to-scf"]],
                          ["vector", "gpu", ["-convert-vector-to-gpu"]],
                          ["affine.for", "gpu", [
                              "-pass-pipeline=\"builtin.module(func.func(convert-affine-for-to-gpu{gpu-block-dims=1 gpu-thread-dims=0}))\""]],
                          ["scf.parallel", "gpu", ["-gpu-map-parallel-loops -convert-parallel-loops-to-gpu"]],
                          ["scf.parallel", "async",
                           ["--async-parallel-for=num-workers=-1", "--async-parallel-for =async-dispatch=true",
                            "--async-parallel-for async-dispatch=false", "--async-parallel-for"]],
                          ["gpu", "async", ["-gpu-kernel-outlining -gpu-async-region"]],
                          ["async", "async", ["-async-to-async-runtime -async-runtime-ref-counting",
                                              "-async-to-async-runtime -async-runtime-ref-counting-opt "]]
                          ]

            # 1. c.func(convert - affine - for -to - gpu  需要转换affine.losd-> memeref.load
            # 2.根据维度取值

            # 根据维度取值 affine-super-vectorize =\"virtual-vector-size=4,8

            for r in proi_lower:
                seeds = self.select_target_seed(conf.Nmax, r[0], 50)
                print(r[0])
                for seed in seeds:
                    sid = seed[0]
                    ops, mlir_content, n, lowerPass = seed[-4:]

                    # 向input_file写入初始种子
                    with open(seed_file, 'w',encoding='utf-8') as f:
                        f.write(mlir_content)

                    selected_pass = random.choice(r[-1])

                    self.MLIRTest(sid, mlir_content, seed_file, output1_file, selected_pass, "L")


                    for i in range(5):
                        trans_pass = random.sample(conf.opts, conf.pass_num)
                        selected_pass = ' '.join(trans_pass)
                        self.MLIRTest(sid, mlir_content, seed_file, output_file, selected_pass,"T")

            seeds = self.select_seed(conf.Nmax,1000)
            for selected_seed in seeds:
                sid = selected_seed[0]
                ops, mlir_content, n, lowerPass = selected_seed[-4:]

                # 向input_file写入初始种子
                with open(seed_file, 'w',encoding='utf-8') as f:
                    f.write(mlir_content)

                candidate_pass = IRaware_pass_selection(self.config,ops)
                if candidate_pass == []:
                    continue
                selected_pass = random.choice(candidate_pass)
                self.MLIRTest(sid, mlir_content, seed_file, output1_file, selected_pass,"L")
                # os.system("cat " + output1_file)

                for i in range(5):
                    trans_pass = random.sample(conf.opts, conf.pass_num)
                    selected_pass = ' '.join(trans_pass)
                    self.MLIRTest(sid, mlir_content, seed_file, output_file, selected_pass,"T")

        else:
            seeds = self.select_seed(conf.Nmax,1)
            for selected_seed in seeds:
                sid = selected_seed[0]
                ops, mlir_content, n, lowerPass = selected_seed[-4:]

                # 向input_file写入初始种子
                with open(seed_file, 'w',encoding='utf-8') as f:
                    f.write(mlir_content)

                #random testing
                if(fuzz_mode=="rt"):
                    selected_pass = random.choice(conf.opts)
                    # selected_pass = '-test-pass-crash'
                    self.MLIRTest(sid, mlir_content, seed_file, output_file, selected_pass,"")

                if (fuzz_mode == "2rt"):
                    # lowering
                    selected_pass = random.choice(conf.opts_lower)
                    self.MLIRTest(sid, mlir_content, seed_file, output1_file, selected_pass,"L")

                    # transforamtion
                    # selected_pass = random.choice(conf.opts_trans)
                    for i in range(5):
                        trans_pass = random.sample(conf.opts, conf.pass_num)
                        selected_pass = ' '.join(trans_pass)
                        self.MLIRTest(sid, mlir_content, seed_file, output_file, selected_pass,"T")

                if (fuzz_mode == "D"):
                    # lowering
                    candidate_pass = IRaware_pass_selection(self.config,ops)
                    if candidate_pass == []:
                        continue
                    selected_pass = random.choice(candidate_pass)
                    self.MLIRTest(sid, mlir_content, seed_file, output1_file, selected_pass,"L")
                    
                    #随机进行10次转换
                    for i in range(10):
                        trans_pass = random.sample(conf.opts, conf.pass_num)
                        selected_pass = ' '.join(trans_pass)
                        self.MLIRTest(sid, mlir_content, seed_file, output_file, selected_pass,"T")

                    # #基于大模型的合成变异
                    # mutator = MLIRMutator(date = self.sqlname)
                    
                    # try:
                    #     opsjson = eval(ops)  # 将字符串转换为字典
                    # except (SyntaxError, NameError):
                    #     opsjson = ""
                    #     raise ValueError("The provided string is not a valid dictionary format.")

                    # if not opsjson:
                    #     dialect = "linalg"
    
                    # max_length = max(len(v) for v in opsjson.values())
                    # max_keys = [k for k, v in opsjson.items() if len(v) == max_length]
                    
                    # #分析函数中OP最多的方言
                    # dialect =  random.choice(max_keys) if max_keys else "linalg"
                    # #执行变异
                    # mutate_mlir_content = mutator.mutate(mlir_content, dialect)
                    # if mutate_mlir_content is not None:
                    #     IRAnalysis(mutate_mlir_content)
                    #     candidate_pass = IRaware_pass_selection(self.config,ops)
                    #     if candidate_pass != []:
                    #         selected_pass = random.choice(candidate_pass)
                    #         self.MLIRTest(sid, mutate_mlir_content, seed_file, output2_file, selected_pass,"M")
                    
                    #     #随机进行10次转换
                    #     for i in range(10):
                    #         trans_pass = random.sample(conf.opts, conf.pass_num)
                    #         selected_pass = ' '.join(trans_pass)
                    #         self.MLIRTest(sid, mutate_mlir_content, seed_file, output_file, selected_pass,"MT")

                if (fuzz_mode == "L"):
                    # lowering
                    candidate_pass = IRaware_pass_selection(self.config,ops)
                    if candidate_pass == []:
                        continue
                    selected_pass = random.choice(candidate_pass)
                    self.MLIRTest(sid, mlir_content, seed_file, output1_file, selected_pass,"L")








