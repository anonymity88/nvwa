# -*- coding: utf-8 -*-
import os
import re
import subprocess

date = "1011"

def convert_to_gcov(directory, gcov_directory):
    # 创建目标文件夹，存放gcov文件
    if not os.path.exists(gcov_directory):
        os.makedirs(gcov_directory)

    for dirpath, dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.gcno'):
                file_path = os.path.join(dirpath, filename)
                # subprocess.run(['llvm-cov', 'gcov', '-b', '-c', file_path])
                # # 将gcov文件移动到目标目录
                # subprocess.run('mv *.gcov ' + gcov_directory, shell=True)
                subprocess.run(['llvm-cov','gcov', '-b', '-c', file_path],cwd=gcov_directory)                

    

def coverage_stat(directory):
    total_lines, covered_lines = 0, 0
    total_branches, taken_branches = 0, 0

    # 遍历目录下的所有gcov文件
    for dirpath, dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.gcov'):
                with open(os.path.join(dirpath, filename)) as f:
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

    results = []

    results.extend([total_lines,covered_lines,line_coverage_perc,total_branches,taken_branches,branch_coverage_perc])
    
    log_file = f"fuzz_results/{date}/coverage_{date}.log"

    # 打开文件用于写入，如果文件不存在则创建
    with open(log_file, 'w') as log_file:
        # 写入其他统计信息
        log_file.write(f"Total Lines: {results[0]}\n")
        log_file.write(f"Covered Lines: {results[1]}\n")
        log_file.write(f"Line Coverage: {results[2]:.2f}%\n")
        log_file.write(f"Total Branches: {results[3]}\n")
        log_file.write(f"Taken Branches: {results[4]}\n")
        log_file.write(f"Branch Coverage: {results[5]:.2f}%\n")


gcov_directory = f"fuzz_results/{date}/gcov"
directory = "/home/llm/llvm-project/build/tools/mlir"
convert_to_gcov(directory,gcov_directory)
coverage_stat(gcov_directory)