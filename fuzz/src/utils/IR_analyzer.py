# -*- coding: utf-8 -*-
# import sys
# sys.path.append(r"/../Documents/MLIR/MLIR_code")


# v0.10.1及以下
import os
import subprocess
import sys
import pymysql
import signal
import datetime
import re
import json

sys.path.append('../')
from utils import *
from utils.logger_tool import log
from utils.config import Config

#分析IR中的方言和算子，保存为json
def IRAnalysis(content):
    # 所有方言的集合
    dialectSet = {'acc', 'affine', 'amdgpu', 'amx', 'arith', 'arm_neon', 'arm_sve', 'arm_sme', 'async',
                  'bufferization',
                  'cf', 'complex', 'dlti', 'emitc', 'func', 'gpu', 'index', 'irdl', 'linalg', 'llvm', 'math',
                  'memref',
                  'mesh', 'ml_program', 'mpi', 'nvgpu', 'nvvm', 'omp', 'pdl_interp', 'pdl', 'polynomial', 'quant',
                  'rocdl',
                  'scf', 'shape', 'sparse_tensor', 'tensor', 'ub', 'vcix', 'vector', 'x86vector', 'xegpu', 'spriv',
                  'tosa',
                  'transform'}

    # 读取IR使用的方言，放入diaList
    diaList = []
    for dialect in dialectSet:
        if dialect + '.' in content:
            diaList.append(dialect)

    # 读取每一个IR使用的op,放入dia_dict
    dia_dict = {}
    for dialect in diaList:
        dia_dict[dialect] = []
        ops = re.findall(dialect + r'\.\w+', content)
        opNameSet = set()
        for op in ops:
            opNameSet.add(op)
        for opName in opNameSet:
            dia_dict[dialect].append(opName)

    # 转json
    json_result = json.dumps(dia_dict, indent=4)
    return json_result


#pass selection based-IR-aware
def IRaware_pass_selection(config, IR_ops):
    pass_list = []
    try:
        IR_ops = json.loads(IR_ops)  # str转字典
    except json.decoder.JSONDecodeError:
        print("JSONDecodeError: No valid JSON object could be decoded from the string.")
        return pass_list
    
    dependency = config.dependency_lower

    # 打印所有key值
    for key in IR_ops.keys():
        # print(key)
        # print(self.config.dependency_lower[key])
        if key == "func" or key not in dependency.keys():
            continue
        for d_ops in dependency[key]["OPS"]:
            d_ops = [s.replace("-", "") for s in d_ops]
            has_common = bool(set(d_ops) & set(IR_ops[key]))  # 将两个列表转换为集合，然后使用集合的交集操作来判断是否有相同的元素
            # print(d_ops)
            # print(IR_ops[key])
            if has_common:
                index = dependency[key]["OPS"].index(d_ops)
                pass_ = dependency[key]["PASS"][index]
                pass_list.append(pass_)
                # print(pass_)
        if key == "linalg":
            pass_list.extend(dependency[key]["PASS"])
    # print(pass_list)
    return pass_list