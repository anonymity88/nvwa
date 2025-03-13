# -*- coding: utf-8 -*-
import argparse
import sys
import re
import time
import json
import datetime
from utils.config import Config
from utils import *
from utils import logger_tool
from utils import dbutils
from fuzz.reporter import *
import os
from utils.logger_tool import log

sys.path.append('/home/llm/generate')


def get_args():
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('--opt', required=True,choices=['L', 'LF', 'F'])
    arg_parser.add_argument('--seedpath', required=True)
    arg_parser.add_argument('--sqlName',required=True)
    arg_parser.add_argument('--Mut',default='0',choices=['0', '1', '2', '3'])  #no mix rep mut
    arg_parser.add_argument('--fuzz_mode',default='P',choices=['rt', '2rt','D','dt','L','P'])
    arg_parser.add_argument('--debug',default='0',choices=['0', '1'])
    arg_parser.add_argument('--path',default='default')
    return arg_parser.parse_args(sys.argv[1:])


def main():
    args = get_args()
    config_path = '/home/llm/fuzz/conf/conf.yml'  # 配置文件路径
    conf = Config(config_path,args)
    
    logger_tool.get_logger()
    dbutils.db = dbutils.myDB(conf)
    
    #模式
    opt = args.opt

    #载入模式
    if(opt == "LF" or opt == "L"):
        #load
        from utils.tosaGen import create_new_table, load_cases
        # initialize database
        # create_new_table(conf)

        load_cases(conf, args.seedpath)

        if(opt == "LF"):
            opt == "F"

    #仅测试模式
    if(opt == "F"):
        #fuzz
        from fuzz.fuzz import Fuzz
        reporter = Reporter(conf)
        fuzzer = Fuzz(conf, reporter, args.sqlName)

        start = datetime.datetime.now()
        end = start + datetime.timedelta(minutes=conf.run_time)
        st= start.timestamp()
        nt = st
        while (nt-st<conf.run_time):
            now = datetime.datetime.now()
            nt= now.timestamp()
            if args.debug != '0':
                fuzzer.debug()
                break
            fuzzer.process(args.Mut,args.fuzz_mode)
            if now.__gt__(end):
                break
        print("time out!!!")



# RUN : timeout 86400s python /home/llm/fuzz/src/main.py --seedpath=/home/llm/generate_results/mutate_IRs/Tosa --sqlName=1011 --opt=F
if __name__ == '__main__':
    main()
