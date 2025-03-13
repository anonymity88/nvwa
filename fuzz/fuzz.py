import os
import numpy as np
import time
import signal
import subprocess
import shutil
from datetime import datetime, timedelta
import random
import psutil
import json

# 常量定义
opts = []
with open('fuzz/opts.txt', 'r') as f:
    opts = [opt.strip() for opt in f.readlines()]

date = "1014"
mlir_opt = "llvm-project/build/bin/mlir-opt"
seeds_dir = f"fuzz_results/{date}/seeds"
crash_dir = f"fuzz_results/{date}/crash/"
temp_log = "fuzz/temp.log"
mlir_storage_dir = f"fuzz_results/{date}/mlir/"
results_dir = f"fuzz_results/{date}/json"

# 确保存储目录存在
os.makedirs(mlir_storage_dir, exist_ok=True)
os.makedirs(crash_dir, exist_ok=True)
os.makedirs(results_dir, exist_ok=True)

tests_per_file = 100
opts_per_file = 10
timeout_seconds = 24 * 60 * 60  # 24小时

# 设置超时秒数（24小时 = 86400秒）
timeout_seconds = 86400

# 处理超时的函数
def timeout_handler(signum, frame):
    print("到达时间限制，自动停止程序。")
    raise SystemExit(1)  # 触发超时后退出程序

# 设置超时信号处理
signal.signal(signal.SIGALRM, timeout_handler)
signal.alarm(timeout_seconds)  # 设置超时秒数

# 执行命令
def exec_cmd(cmd):
    try:
        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = proc.communicate(timeout=300)
        return proc.returncode
    except subprocess.TimeoutExpired:
        # 超时处理
        parent = psutil.Process(proc.pid)
        for child in parent.children(recursive=True):
            child.kill()
        parent.kill()
        with open(temp_log, 'w') as log_file:
            log_file.write("time out\n")
            log_file.write(f"{cmd}\n")
        return -9

# 保存成功的操作
def save_succeed_opts(filename, succeed_opts):
    succeed_opts_file = os.path.join(results_dir, f"{filename}_succeed_opts.json")
    with open(succeed_opts_file, 'w') as f:
        json.dump(succeed_opts, f)

# 加载成功的操作
def load_succeed_opts(filename):
    succeed_opts_file = os.path.join(results_dir, f"{filename}_succeed_opts.json")
    if os.path.exists(succeed_opts_file):
        with open(succeed_opts_file, 'r') as f:
            return json.load(f)
    return []

# 初次测试MLIR文件
def initial_test(filename):
    succeed_opts = []
    mlir_file = os.path.join(seeds_dir, filename)
    stored_mlir_file = os.path.join(mlir_storage_dir, filename)
    shutil.copy(mlir_file, stored_mlir_file)

    for opt in opts:
        cmd = f"{mlir_opt} {opt} {stored_mlir_file} 1>/dev/null 2>{temp_log}"
        state = exec_cmd(cmd)
        print(f"{state}: {cmd}")
        if state > 130 or state == -6 or state == -9:
            crashlog = os.path.join(crash_dir, f"{filename}_{hash(opt)}.log")
            current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            with open(temp_log, 'r') as log_file:
                log_content = log_file.read()
            with open(temp_log, 'w') as log_file:
                log_file.write(f"{current_time}\ncmd:{cmd}\n\n{log_content}")
            cmd = f"mv {temp_log} {crashlog}"
            os.system(cmd)
        else:
            succeed_opts.append(opt)

    save_succeed_opts(filename, succeed_opts)
    return succeed_opts

# 测试MLIR文件
def test_mlir_file(filename, succeed_opts):
    mlir_file = os.path.join(seeds_dir, filename)
    stored_mlir_file = os.path.join(mlir_storage_dir, filename)
    shutil.copy(mlir_file, stored_mlir_file)
    
    for i in range(tests_per_file):
        idxes = np.random.randint(0, len(succeed_opts), opts_per_file)
        np.random.shuffle(idxes)
        cmd = mlir_opt
        opt_str = ""
        for idx in idxes:
            opt_str += succeed_opts[idx]
            cmd += f" {succeed_opts[idx]}"
        cmd += f" {stored_mlir_file} 1>/dev/null 2>{temp_log}"
        state = exec_cmd(cmd)
        print(f"{state}: {cmd}")
        if state > 130 or state == -6 or state == -9:
            crashlog = os.path.join(crash_dir, f"{filename}_{hash(opt_str)}.log")
            timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            with open(temp_log, 'r') as log_file:
                log_content = log_file.read()
            with open(temp_log, 'w') as log_file:
                log_file.write(f"{timestamp}\ncmd:{cmd}\n\n{log_content}")
            cmd = f"mv {temp_log} {crashlog}"
            os.system(cmd)

# 运行测试的函数
def run_tests():
    iteration = 0  # 记录迭代次数

    while True:
        # 第一次随机打乱文件顺序，之后按文件大小顺序
        mlir_files = [f for f in os.listdir(seeds_dir) if f.endswith('.mlir')]
        #当第二次迭代之后，记录测试次数
        # testcount = len(mlir_files)
        
        if iteration == 0:
            # 第一次迭代时随机排列文件
            random.shuffle(mlir_files)
        else:
            # 第二次及之后按文件大小排序
            mlir_files.sort(key=lambda f: os.path.getsize(os.path.join(seeds_dir, f)), reverse=True)

        for filename in mlir_files:
            succeed_opts = load_succeed_opts(filename)
            if not succeed_opts:
                succeed_opts = initial_test(filename)
            test_mlir_file(filename, succeed_opts)
            
            #当第二次迭代之后，每次测试都要记录次数
            # if iteration != 0:
            #     testcount += 1
            #     with open(f"fuzz_results/{date}/testcount.txt", 'w') as f:
            #         f.write(f"total testcount:{testcount}")

        iteration += 1  # 完成一次迭代


# 主函数
def main():
    run_tests()

if __name__ == "__main__":
    main()
