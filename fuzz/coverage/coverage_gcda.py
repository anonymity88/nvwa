import os
import re
import subprocess
import datetime

date = "1014"

def convert_to_gcov(directory, gcov_directory):
    # 创建目标文件夹，存放gcov文件
    if not os.path.exists(gcov_directory):
        os.makedirs(gcov_directory)

    for dirpath, dirs, files in os.walk(directory):
        for filename in files:
            if filename.endswith('.gcda'):
                file_path = os.path.join(dirpath, filename)
                # subprocess.run(['llvm-cov', 'gcov', '-b', '-c', file_path])
                # # 将gcov文件移动到目标目录
                # subprocess.run('mv *.gcov ' + gcov_directory, shell=True)
                subprocess.run(['llvm-cov','gcov', '-b', '-c', file_path],cwd=gcov_directory)


def coverage_stat(directory, log_file, i):
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
    
    # 打开文件用于写入，如果文件不存在则创建
    with open(log_file, 'a') as log_file:
        # 写入当前日期和时间
        # log_file.write(f"{datetime.datetime.now()}\n")
        log_file.write(f"Times:{i}\n")
        # 写入其他统计信息
        log_file.write(f"Total Lines: {results[0]}\n")
        log_file.write(f"Covered Lines: {results[1]}\n")
        log_file.write(f"Line Coverage: {results[2]:.2f}%\n")
        log_file.write(f"Total Branches: {results[3]}\n")
        log_file.write(f"Taken Branches: {results[4]}\n")
        log_file.write(f"Branch Coverage: {results[5]:.2f}%\n")




# 保存gcda文件的路径
directory = f"/home/llm/fuzz_results/{date}/gcdafiles"
# 覆盖率log文件路径
log_file = f"/home/llm/fuzz_results/{date}/coverage_llm_{date}.log"
# gcov文件路径
gcov_directory = f"/home/llm/fuzz_results/{date}/gcovfiles"


for i, subdir in enumerate(sorted(os.listdir(directory))):
    gcda_directory = os.path.join(directory, subdir)
    # 检查是否为目录
    if os.path.isdir(gcda_directory):
        gcov_files = f"{gcov_directory}/gcov_{i}"
        
        # 执行转换函数
        convert_to_gcov(gcda_directory, gcov_files)
        # 统计覆盖率
        coverage_stat(gcov_files, log_file, i)
