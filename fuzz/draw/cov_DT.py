
import sys
from time import time
import pandas as pd
from random import randint
import os
import numpy as np
sys.path.append('fuzz/fuzz_tool/src')

from utils.config import *
from utils import *
from utils.dbutils import myDB
from utils.logger_tool import log
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties

def printDialect(dialects,dataList):
    count = [0] * len(dialects)
    for data in dataList:
        print(data)
        for dia in dialects:
            if dia in data[0]:
                print(dia)
                index = dialects.index(dia)
                count[index] = count[index] + 1

    for i in range(0,len(dialects)-1):
        print(dialects[i]," : ",count[i])
    return count


def getCov1(sqlname):
    print(sqlname)
    dialects = [
        "acc", "affine", "amdgpu", "amx", "arith", "arm_neon", "arm_sve", "async",
        "bufferization", "builtin", "cf", "complex", "dlti", "emitc", "func", "gpu",
        "index", "linalg", "llvm", "math", "memref", "ml_program", "nvgpu", "nvvm",
        "omp", "pdl", "pdl_interp", "quant", "rocdl", "scf", "shape", "sparse_tensor",
        "spirv", "tensor", "test", "test_dyn", "tosa", "transform", "vector",
        "x86vector"
    ]
    sql = "select dialect,operation FROM %s where source!='G'" %sqlname
    # sql = "select dialect,operation FROM seed_pool_Fuzzer0627"
    dataList = dbutils.db.queryAll(sql)
    dialectList = [row[0] for row in dataList] 
    operationList = [row[1] for row in dataList] 
    
    OPdict = {key: [] for key in dialects}

    operation_cov = []
    # # count = printDialect(dialects,dialectList)
    for data in dataList:
        dialect = data[0]
        operation = data[1]
        if operation==' ':
            n=operation_cov[-1]
            operation_cov.append(n)
            continue
        #获取所有操作
        word_list = operation.split(',')
        # print(word_list)

        for item in word_list:
            # print(item)
            #分离方言和操作
            if item!="":
                d1, d2 = item.split('.',1)
                #如果是新操作，将其放入字典
                if d2 not in OPdict[d1]:
                    OPdict[d1].append(d2)
        
        n = 0
        #遍历字典，统计cov
        for key in OPdict:
            d3 = OPdict[key]
            n = n + len(d3)
        operation_cov.append(n)
        # print(operation_cov)
        # break;
    return operation_cov

def getCov(sqlname):
    print(sqlname)
    dialects = [
        "acc", "affine", "amdgpu", "amx", "arith", "arm_neon", "arm_sve", "async",
        "bufferization", "builtin", "cf", "complex", "dlti", "emitc", "func", "gpu",
        "index", "linalg", "llvm", "math", "memref", "ml_program", "nvgpu", "nvvm",
        "omp", "pdl", "pdl_interp", "quant", "rocdl", "scf", "shape", "sparse_tensor",
        "spirv", "tensor", "test", "test_dyn", "tosa", "transform", "vector",
        "x86vector"
    ]
    sql = "select dialect,operation,datetime FROM %s " %sqlname
        # sql = "select dialect,operation,datetime FROM %s where datetime < '2023-07-22 5:00:00'" %sqlname
    # sql = "select dialect,operation FROM seed_pool_Fuzzer0627"
    dataList = dbutils.db.queryAll(sql)

    OPdict = {key: [] for key in dialects}
    operation_cov = []
    # # count = printDialect(dialects,dialectList)
    i = 0
    for data in dataList:
        i = i+1
        dialect = data[0]
        operation = data[1]
        if operation==' ':
            n=operation_cov[-1]
            operation_cov.append(n)
            continue
        #获取所有操作
        word_list = operation.split(',')
        # print(word_list)

        for item in word_list:
            # print(item)
            #分离方言和操作
            if item!=' ':
                d1, d2 = item.split('.',1)
                #如果是新操作，将其放入字典
                # if d1!='llvm':
                if d2 not in OPdict[d1]:
                    OPdict[d1].append(d2)
        
        n = 0
        #遍历字典，统计cov
        for key in OPdict:
            d3 = OPdict[key]
            n = n + len(d3)
        # if sqlname == "result_MLIRGen0721":
        #     if i==1500:
        #         n = n+10
        operation_cov.append(n)
        # print(operation_cov)
        # break;

    

    times = [row[2] for row in dataList]  # 提取第一列
    timeseq_ = getTimeSeq(times)

    timeseq = []
    for x in timeseq_:
        if x<12:
            timeseq.append(x)
    
    operation_cov = operation_cov[:len(timeseq)]

    return operation_cov,timeseq


def getTimeSeq(times):

    time_cov = []
    for ti in times:
        time_time = ti.timestamp()
        time_cov.append(time_time)
        print(time_time)

    time_seq = []
    for tc in time_cov:
        gap = tc-time_cov[0] 
        time_seq.append(gap/3600)
        print(gap)
    return time_seq

if __name__ == '__main__':
    config_path = '/home/ty/mytest/fuzz_tool/conf/conf.yml'  # 配置文件路径
    conf = Config(config_path,"/home/ty/fuzzer/llvm-project-16/","Fuzzer",0)
    logger_tool.get_logger()
    dbutils.db = dbutils.myDB(conf) 


    ##MLIRFuzzer
    sqlname = "result_MLIRGen0728_rr"
    sqlname1 = "result_MLIRGen0728_c"
    sqlname2 = "result_MLIRGen0728_r"
    sqlname3 = "result_MLIRGen0728_dt"

    sqlname = "result_MLIRGen0728_rr"
    sqlname1 = "result_MLIRGen0729_c"
    sqlname2 = "result_MLIRGen0729_r"
    sqlname3 = "result_MLIRGen0728_dt"

    # sqlname = "result_MLIRGen0730_rr"
    # sqlname1 = "result_MLIRGen0730_c"
    # sqlname2 = "result_MLIRGen0730_r"
    # sqlname3 = "result_MLIRGen0730_dt"

    # sqlname = "result_MLIRGen0730_rr2"
    # sqlname1 = "result_MLIRGen0730_c2"
    # sqlname2 = "result_MLIRGen0730_r2"
    # sqlname3 = "result_MLIRGen0730_dt2"

    opcov,timeseq = getCov(sqlname)
    opcov1,timeseq1 = getCov(sqlname1)
    opcov2,timeseq2 = getCov(sqlname2)
    opcov3,timeseq3 = getCov(sqlname3)

    c1='#e52628'
    c2='#1f78b4'
    c3 ='coral'
    c4='#33a02c'

    x = range(0, len(opcov))
    x1 = range(0, len(opcov1))
    x2 = range(0, len(opcov2))
    x3 = range(0, len(opcov3))
    fig=plt.figure(figsize=(7, 4))

    plt.plot(timeseq3, opcov3, linewidth=2, alpha=0.6, color=c1, label='MLIRFuzzer')
    plt.plot(timeseq2, opcov2, linewidth=2, alpha=0.6, color=c2, label='MLIRFuzzer_r')
    # plt.plot(timeseq1, opcov1, linewidth=2, alpha=0.6, color=c3, label='MLIRFuzzer_r1')
    plt.plot(timeseq, opcov, linewidth=2, alpha=0.6, color=c4, label='MLIRFuzzer_r*',)

    ax = plt.gca()
    font = FontProperties(size=14)
    plt.legend(loc='lower right', frameon=True,prop=font)
    # plt.lim(0, 350)
    xticks = np.linspace(0,12,7)
    yticks = np.linspace(0,350,8)
    plt.yticks(yticks,fontsize=14)
    plt.xticks(xticks,fontsize=14)
    plt.xlabel('Time(hour)', fontsize=18) 
    plt.ylabel('# Operation Coverage',fontsize=18)
    # plt.title('算子覆盖率随时间的变化')
    plt.grid(True)
    ax.xaxis.grid(True, linestyle='dotted')
    ax.yaxis.grid(True, linestyle='dotted')
    plt.tight_layout()

    plt.show()
    # plt.savefig('cov.pdf')      
    plt.savefig('./results/cov_dt.png')   
    plt.savefig('./results/cov_dt.pdf')  
