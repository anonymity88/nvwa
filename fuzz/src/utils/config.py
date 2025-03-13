import yaml
import os
import time
import json

def load_conf(conf_path):
    with open(conf_path, 'r',encoding='utf-8') as f:
        content = f.read()
    conf = yaml.load(content, Loader=yaml.FullLoader)
    return conf


class Config:
    def __init__(self, conf_path,args):
        sqlName = args.sqlName

        path_mlir_opt = args.path

        conf = load_conf(conf_path)

        common = conf['common']
        database = conf['database']
        generator = conf['generator']
        fuzz = conf['fuzz']
        report = conf['report']

        # common config
        if path_mlir_opt == "default":
            self.mlir_opt = common['opt_executable']
        else:
            self.mlir_opt = path_mlir_opt

        # database config
        self.host = database['host']
        self.port = database['port']
        self.username = database['username']
        self.passwd = database['passwd']

        self.db = database['db']
        # self.db = args.fuzz_mode

        label = sqlName
        self.seed_pool_table = 'seed_pool_' + label
        self.result_table = 'result_' + label
        self.report_table = 'report_' + label

        # generator config
        self.mlirfuzzer_opt = common['project_path'] + generator['generator_executable']
        self.empty_func_file = generator['empty_func_file']
        self.count = generator['count']

        # fuzz config
        self.run_time = fuzz['run_time']
        self.Nmax = fuzz['seed_select_num']
        self.pass_num = fuzz['pass_num']
        self.temp_dir = common['project_path']+ fuzz['temp_dir']

        #保存bug信息
        self.bugs_info = []


        # 加载所有pass
        passes = []
        with open(fuzz['opt_file'], 'r') as f:
            for line in f.readlines():
                passes.append(line.replace('\n', ''))
        self.opts = passes

        # 加载lower pass
        passes = []
        with open(fuzz['lower_file'], 'r') as f:
            for line in f.readlines():
                passes.append(line.replace('\n', ''))
        self.opts_lower = passes

        # 加载转换pass
        passes = []
        with open(fuzz['trans_file'], 'r') as f:
            for line in f.readlines():
                passes.append(line.replace('\n', ''))
        self.opts_trans = passes


        #创建临时目录，保存中间文件
        self.temp_dir = self.temp_dir+"temp."+ str(hash(time.time())) +"/"
        if not os.path.exists(self.temp_dir):
            os.makedirs(self.temp_dir)

        # 加载lower-dependency
        passes = []
        with open(fuzz['lower_dependency'], 'r') as f:
            jsonData = json.load(f)
        self.dependency_lower = jsonData





        # 3. report config
        self.savepath = report['savepath']

        self.Iter = 0

