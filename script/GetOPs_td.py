#本程序用于从.td文件中提取各方言OP的定义
import os
import re

# 设置路径
base_dir = "/home/llm/llvm-project/mlir/include/mlir/Dialect"
output_dir = "/home/llm/OPs"

# 创建输出目录
os.makedirs(output_dir, exist_ok=True)

# 定义正则表达式来匹配操作定义的开始
op_start_re_1 = re.compile(
    r"//===----------------------------------------------------------------------===//\n"
    r"// Operator: (\w+)\n"
    r"//===----------------------------------------------------------------------===//"
)

op_start_re_2 = re.compile(
    r"//===----------------------------------------------------------------------===//\n"
    r"// (\w+Op)\n"
    r"//===----------------------------------------------------------------------===//"
)

# 定义操作定义的结束标志
op_end_re = re.compile(r"//===----------------------------------------------------------------------===//")

# 记录处理过的方言
processed_dialects = set()

# 遍历每个方言的目录
for dialect in os.listdir(base_dir):
    dialect_dir = os.path.join(base_dir, dialect)

    # 标记是否找到操作定义文件
    found_ops = False

    # 递归查找可能的 .td 文件
    for root, dirs, files in os.walk(dialect_dir):
        for file in files:
            if file.endswith(".td"):  # 匹配所有的 .td 文件
                ops_file = os.path.join(root, file)

                # 读取 .td 文件内容
                with open(ops_file, "r") as f:
                    lines = f.readlines()

                current_op = []
                op_name = None

                i = 0
                while i < len(lines):
                    line = lines[i]

                    # 检查是否遇到第一种形式的操作定义的开始
                    if i+2 < len(lines) and op_start_re_1.match(line + lines[i+1] + lines[i+2]):
                        found_ops = True
                        if current_op and op_name:
                            op_dir = os.path.join(output_dir, dialect)
                            os.makedirs(op_dir, exist_ok=True)
                            op_file_path = os.path.join(op_dir, f"{op_name.lower()}.txt")
                            with open(op_file_path, "w") as op_file:
                                op_file.writelines(current_op)

                        match = op_start_re_1.match(line + lines[i+1] + lines[i+2])
                        op_name = f"{dialect.lower()}.{match.group(1).lower()}"
                        current_op = [line, lines[i+1], lines[i+2]]
                        i += 3
                        continue

                    # 检查是否遇到第二种形式的操作定义的开始
                    if i+2 < len(lines) and op_start_re_2.match(line + lines[i+1] + lines[i+2]):
                        found_ops = True
                        if current_op and op_name:
                            op_dir = os.path.join(output_dir, dialect)
                            os.makedirs(op_dir, exist_ok=True)
                            op_file_path = os.path.join(op_dir, f"{op_name.lower()}.txt")
                            with open(op_file_path, "w") as op_file:
                                op_file.writelines(current_op)

                        match = op_start_re_2.match(line + lines[i+1] + lines[i+2])
                        op_name_raw = match.group(1).lower()
                        if op_name_raw.endswith('op'):
                            op_name_raw = op_name_raw[:-2]  # 移除末尾的 "op"
                        op_name = f"{dialect.lower()}.{op_name_raw}"
                        current_op = [line, lines[i+1], lines[i+2]]
                        i += 3
                        continue

                    if current_op:
                        current_op.append(line)

                    if op_end_re.match(line) and current_op:
                        if i+3 < len(lines) and (op_start_re_1.match(lines[i+1] + lines[i+2] + lines[i+3]) or 
                                                  op_start_re_2.match(lines[i+1] + lines[i+2] + lines[i+3])):
                            op_dir = os.path.join(output_dir, dialect)
                            os.makedirs(op_dir, exist_ok=True)
                            if op_name:
                                op_file_path = os.path.join(op_dir, f"{op_name.lower()}.txt")
                                with open(op_file_path, "w") as op_file:
                                    op_file.writelines(current_op)
                            current_op = []
                            op_name = None

                    i += 1

                if current_op and op_name:
                    op_dir = os.path.join(output_dir, dialect)
                    os.makedirs(op_dir, exist_ok=True)
                    op_file_path = os.path.join(op_dir, f"{op_name.lower()}.txt")
                    with open(op_file_path, "w") as op_file:
                        op_file.writelines(current_op)

    # 如果找到了操作定义文件，就记录这个方言
    if found_ops:
        processed_dialects.add(dialect)

# 输出处理过的方言
print(f"处理过的方言数量: {len(processed_dialects)}")
print(f"处理过的方言: {sorted(processed_dialects)}")
