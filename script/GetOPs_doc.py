import os
import re

# 源文件路径
input_file = 'test/Corpus.txt'

# 目标文件夹
output_dir = 'specifications/transform'

# 确保文件夹存在，不存在则创建
os.makedirs(output_dir, exist_ok=True)

# 读取源文件内容
with open(input_file, 'r', encoding='utf-8') as file:
    content = file.read()

# 正则表达式匹配模式如 scf.condition (scf::ConditionOp)
pattern = re.compile(r'^(transform\.[\w\.]+ \(\s*transform::[^\)]+\)\s*¶?)$', re.MULTILINE)

# 查找所有操作定义的开始位置
matches = list(pattern.finditer(content))

# 检查是否找到匹配项
if not matches:
    print("No operation definitions found.")
    exit()

# 遍历每个匹配的操作，将其分割并保存为 .txt 文件
for i in range(len(matches)):
    # 获取当前操作的开始位置和标题行
    start = matches[i].start()
    op_title = matches[i].group(1)
    
    # 获取下一个操作的开始位置，或者文件末尾
    end = matches[i+1].start() if i + 1 < len(matches) else len(content)
    
    # 获取操作名（scf.OP_name）
    op_name = op_title.split()[0]
    
    # 获取当前操作的内容
    op_content = content[start:end].strip()
    
    # 生成文件名，如 scf.condition.txt
    file_name = f"{op_name}.txt"
    file_path = os.path.join(output_dir, file_name)
    
    # 保存内容到 .txt 文件
    with open(file_path, 'w', encoding='utf-8') as op_file:
        op_file.write(op_content)
    
    print(f"Saved {file_name}")

print("All OPs have been saved.")
