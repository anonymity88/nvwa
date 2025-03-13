import subprocess
import re

# 运行 mlir-opt --help 命令以获取 Pass 列表
output = subprocess.check_output(["mlir-opt", "--help"], text=True)
print(output)

# 使用正则表达式从输出中提取 Pass 名称
pass_pattern = re.compile(r"--(\S+)\s+")
passes = pass_pattern.findall(output)
print(len(passes))

# 为每个pass名称添加前缀 "--"
for i in range(len(passes)):
    passes[i] = "--" + passes[i]

print(passes)
print(len(passes))

# 将passes逐行写入opt.txt文件
with open("opt.txt", "w") as file:
    for p in passes:
        file.write(p + "\n")

# 打印每行最多包含10个pass的组合（可选）
for i in range(0, len(passes), 10):
    print(' '.join(passes[i:i+10]))

