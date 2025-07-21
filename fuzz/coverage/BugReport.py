# -*- coding: utf-8 -*-
import sys
import os
import re
import shutil  # 用于复制文件

sys.path.append('../')


date = "deepseek"

# 初始化一个空列表来存储bug信息
BugList = []

# 定义文件夹路径
folder_path = f"fuzz_results/{date}/crash"
dedup_folder_path = f"fuzz_results/{date}/crash_deduplicate"  # 目标文件夹路径

# 如果目标文件夹不存在，则创建
if not os.path.exists(dedup_folder_path):
    os.makedirs(dedup_folder_path)

# 按文件修改时间排序并处理 .log 文件
log_files = [
    os.path.join(folder_path, filename)
    for filename in os.listdir(folder_path)
    if filename.endswith('.log') and os.path.isfile(os.path.join(folder_path, filename))
]

# 按修改时间排序，从先到后
log_files.sort(key=lambda file: os.path.getmtime(file))

# 遍历排序后的文件并读取内容
for file_path in log_files:
    with open(file_path, 'r') as file:
        content = file.read()  # 读取文件内容

        errorFunc = ''
        errorMessage = ''
        
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
                    errorFunc = errorFunc.split("/home")[0]  # 去掉报错的地址
                    errorFunc = errorFunc[22:]
                    break
            errorMessage = "Segmentation fault:" + errorFunc
        elif content.find("Aborted") >= 0:
            for i in range(0, len(content_list) - 1):
                if content_list[i].find("abort") >= 0:
                    errorFunc = content_list[i + 2]  # 提取__restore_rt下面的一行
                    errorFunc = errorFunc.split("/home")[0]  # 去掉报错的地址
                    errorFunc = errorFunc[23:]
                    errorMessage = errorFunc
                    break    

        elif content.find("time out") >= 0:
            errorMessage = "time out"
            
        # 检查bug_info是否已经存在于列表中
        if errorMessage not in BugList:
            BugList.append(errorMessage)
            # 复制文件到指定文件夹
            shutil.copy(file_path, dedup_folder_path)


# 将BugList写入文件
with open(f'fuzz_results/{date}/BugList_{date}.txt', 'w') as file:
    for item in BugList:
        file.write(f"{item}\n\n")
        