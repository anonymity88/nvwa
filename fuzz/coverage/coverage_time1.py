# -*- coding: utf-8 -*-
import os
import re
import subprocess
import time
import numpy as np
import sys

# 获取命令行参数
arg1 = sys.argv[1] # 数据库名
arg2 = sys.argv[2] # fuzzer number

def convert_to_gcov(directory, gcov_directory):
    # 创建目标文件夹，存放gcov文件
    i = 0
    if not os.path.exists(gcov_directory):
        os.makedirs(gcov_directory)
    for dirpath, dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.gcda'):
                i = i+1
                file_path = os.path.join(dirpath, filename)
                print(i,file_path)
                subprocess.run(['cp','-rf',file_path,gcov_directory])
            if filename.endswith('.gcno'):
                file_path = os.path.join(dirpath, filename)
                print(i,file_path)
                subprocess.run(['cp','-rf',file_path,gcov_directory])


                # print('cp',file_path,gcov_directory)
                # subprocess.run(['gcov', '-b', '-c', file_path],cwd=gcov_directory)
                # 将gcov文件移动到目标目录
                # subprocess.run('mv *.gcov ' + gcov_directory, shell=True)
def coverage_stat(directory):
    total_lines, covered_lines = 0, 0
    total_branches, taken_branches = 0, 0

    # 遍历目录下的所有gcov文件


    for dirpath, dirs, files in os.walk(directory):
            for filename in files:
                if filename.endswith('.gcda'):
                    file_path = os.path.join(dirpath, filename)
                    subprocess.run(['gcov', '-b', '-c', file_path],cwd=directory)

    for dirpath, dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.gcov'):
                with open(os.path.join(dirpath, filename)) as f:
                    i = i+1
                    print(i,os.path.join(dirpath, filename))
                    for line in f:
                        # 分析被运行过的代码行
                        if re.match(".*:.*:.*", line) and not re.match("^[ ]*-:.*", line):
                            total_lines += 1
                            # print(line)
                            if not re.match("    #####:.*", line):
                                covered_lines += 1
                                # print(line)
                                
                        # 分析被运行过的分支
                        if re.match("branch  .*", line):
                            total_branches += 1
                            if re.match("branch  .*taken", line):
                                taken_branches += 1
        

    # 计算覆盖率
    line_coverage_perc = (covered_lines / total_lines) * 100 if total_lines > 0 else 0
    branch_coverage_perc = (taken_branches / total_branches) * 100 if total_branches > 0 else 0

    print("Total Lines: ", total_lines)
    print("Covered Lines: ", covered_lines)
    print("Line Coverage: {:.2f}%".format(line_coverage_perc))
    print("Total Branches: ", total_branches)
    print("Taken Branches: ", taken_branches)
    print("Branch Coverage: {:.2f}%".format(branch_coverage_perc))
    current_time = time.time()
    print(current_time)
    results = []
    results.append([total_lines,covered_lines,line_coverage_perc,total_branches,taken_branches,branch_coverage_perc,current_time])
    return results

   
gcov_directory = "/home/ty/compiler-testing/fuzz_tool/src/coverage/gcovfiles/gcovfiles_" + str(arg1)
# directory = "/home/ty/compiler-testing/external/llvm/build/tools/mlir"
directory = "/home/ty/"+str(arg2)+"/llvm-project-16/build/tools/mlir"

current_time = time.time()

while (1):
    convert_to_gcov(directory,gcov_directory)
    results = coverage_stat(gcov_directory)

    # 定义一个示例的多维数组
    arr = np.array(results)

    # 将多维数组保存到txt文件
    with open('./results/'+arg1+'_cov.txt', 'a') as f:
        np.savetxt(f, arr)
    
    time.sleep(20)

    # # 从txt文件中加载多维数组
    # loaded_arr = np.loadtxt('array.txt')
    # # 打印加载后的多维数组
    # print(len(loaded_arr))