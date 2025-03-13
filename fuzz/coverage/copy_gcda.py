import os
import shutil
import datetime
import time

date = "1014"

# 指定要搜索的目录
search_dir = "/home/llm/llvm-project/build/tools/mlir"

# 指定要复制到的目录
target_dir = f"fuzz_results/{date}/gcdafiles"

if not os.path.exists(target_dir):
    os.makedirs(target_dir)

# 创建以当前时间命名的子文件夹
current_time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
new_dir = os.path.join(target_dir, current_time)
os.makedirs(new_dir, exist_ok=True)

# 搜索.gcda文件并复制到新创建的文件夹
for root, dirs, files in os.walk(search_dir):
    for file in files:
        if file.endswith(".gcda") or file.endswith(".gcno"):
            src_file = os.path.join(root, file)
            dst_file = os.path.join(new_dir, file)
            shutil.copy2(src_file, dst_file)

print(f"copy success! {time.strftime('%m月%d日%H时%M分%S秒')}")