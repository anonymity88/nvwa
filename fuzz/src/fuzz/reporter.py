
import os
import subprocess
import time
import re
import sys
from utils import *

sys.path.append(os.getcwd())


class recordObject:
    def __init__(self,sid,passes, returncode, stderr, mlir, phase,time,duration):
        self.sid = sid
        self.passes = passes
        self.returncode = returncode
        self.stderr = stderr
        self.mlir = mlir
        self.phase = phase  # “”-表示区分状态 opt-优化 lower-降级
        self.time = time
        self.duration = duration



class Reporter:
    def __init__(self, conf):
        sql = "select * from " + conf.report_table + " where stderr is not NULL and stderr != ''"
        data = dbutils.db.queryAll(sql)
        if data:
            for item in data:
                conf.bugs_info.append(item[1])   # 存放当前repor表中的所有的bug信息


    def getCrashInfo(self,content):
        errorFunc = ''
        errorMessage = ''

        # content = content.decode('utf-8')
        content_list = content.split(("\n"))
        if content.find("LLVM ERROR:") >= 0:
            for item in content_list:
                if item.find("LLVM ERROR:") >= 0:
                    errorMessage = "LLVM ERROR:" + item.split("LLVM ERROR:")[1]
        elif content.find("Assertion") >= 0:
            for i in range(0, len(content_list) - 1):
                if content_list[i].find("Assertion") >= 0:
                    # print(content_list[i])
                    num = re.findall(r':(\d+):', content_list[i])
                    if len(num)==0:
                        errorMessage = content_list[i]
                    else:
                        errorMessage = content_list[i].split(num[-1] + ': ')[1]
                    break
        elif content.find("Segmentation fault") >= 0:
            for i in range(0, len(content_list) - 1):
                if content_list[i].find("__restore_rt") >= 0:
                    errorFunc = content_list[i + 1]  # 提取__restore_rt下面的一行
                    errorFunc = errorFunc.split("(/home")[0]  # 去掉报错的地址
                    errorFunc = errorFunc[22:]
                    break
            errorMessage = "Segmentation fault:" + errorFunc
        elif content.find("Aborted") >= 0:
            for i in range(0, len(content_list) - 1):
                if content_list[i].find("abort") >= 0:
                    errorFunc = content_list[i + 2]  # 提取__restore_rt下面的一行
                    errorFunc = errorFunc.split("/home")[0]  # 去掉报错的地址
                    errorFunc = errorFunc[23:]
                    break
            errorMessage = errorFunc
       # elif content.find("Aborted(core dumped)") >= 0:
       #      for i in range(0, len(content_list) - 1):
       #          if content_list[i].find("__restore_rt") >= 0:
       #              errorFunc = content_list[i + 1]  # 提取__restore_rt下面的一行
       #              errorFunc = errorFunc.split("(/home")[0]  # 去掉报错的地址
       #              errorFunc = errorFunc[22:]
       #              break
       #      errorMessage = "" + errorFunc
        else:
            errorMessage = content
        return errorMessage


    def reduce_passes(conf,mlir,passes):
        best_passes = passes[:]
        for pass_to_remove in passes:
            # print(best_passes)
            command = f"{conf.opt_executable} {mlir} {' '.join([p for p in best_passes if p != pass_to_remove])}"
            # print("===remove :"+pass_to_remove)
            # print(command)
            return_code = Fuzz.runMLIR(command)
            if return_code > 130:
                best_passes.remove(pass_to_remove)

        reduced_passes = " ".join(best_passes)
        return reduced_passes


    def report_bug(conf,crash_model):
        mlirfile = crash_model.mlirfile
        cmd_raw = crash_model.cmd_raw
        cmd_reduced = crash_model.cmd_reduced
        returncode = crash_model.returncode
        crash_trace = crash_model.crash_trace
        crash_info = crash_model.crash_info

        dir_str = re.sub(r'[^a-zA-Z0-9]', '', crash_info[:50])
        bug_dir = conf.savepath + str(returncode) + "-" + dir_str

        if not os.path.exists(bug_dir):
            os.makedirs(bug_dir)

        filename = mlirfile.split("/")[-1]
        cp_cmd = "cp " + conf.mlir_dir + filename + " " + bug_dir +"/" + mlirfile.split('/')[-1]
        # print(cp_cmd)
        os.system(cp_cmd)

        result_file_name = bug_dir + "/" + "bug_log.txt"

        # print(result_file_name)

        with open(result_file_name, 'w') as result_file:
            result_file.write(f"Raw passes:\n{cmd_raw}\n")
            result_file.write(f"Reduced passes:\n{cmd_reduced}\n")
            result_file.write(f"\ncrash:\n{''.join(crash_trace)}\n")
            # result_file.write(f"MLIR: {IRs}\n")
