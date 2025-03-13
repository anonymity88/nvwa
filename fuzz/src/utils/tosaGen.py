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

sys.path.append('../')
from utils import *
from utils.logger_tool import log
from utils.config import Config
from utils.IR_analyzer import *

def create_new_table(conf: Config):
    with open('/home/llm/fuzz/conf/init.sql', 'r',encoding="utf-8") as f:
        sql = f.read().replace('seed_pool_table', conf.seed_pool_table) \
            .replace('result_table', conf.result_table) \
            .replace('report_table', conf.report_table)
    try:
        dbutils.db.connect_mysql()
        sql_list = sql.split(';')[:-1]
        for item in sql_list:
            dbutils.db.cursor.execute(item)
        dbutils.db.db.commit()
        print("database init success!")
    except pymysql.Error as e:
        print("SQL ERROR:=======>", e)
    finally:
        dbutils.db.close()

def load_cases(config: Config, folder_path):
    sys.path.append('../')

    mlir_files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if f.endswith('.mlir')]
    count = 0

    # 循环遍历所有txt文件
    for file in mlir_files:
        # file = "/home/ty/mytest/data/nnsmith_mlir_testcase/1797.onnx.mlir"

        candidate_lower_pass = ""
        print("loading", file)
        with open(file, 'r') as f:
            content = f.read()

        operations = IRAnalysis(content)

        # if len(content) > 3000000:
        #     continue
        try:
            sql = "insert into " + config.seed_pool_table + \
                  " (preid,source,operation,content,n, candidate_lower_pass) " \
                  "values ('%s','%s','%s','%s','%s','%s')" \
                  % \
                  (0, 'G', operations, content, 0, candidate_lower_pass)
            # print(sql)
            dbutils.db.executeSQL(sql)
            count = count + 1
        except Exception as e:
            log.error('sql error', e)
        if count == config.count:
            break
    return