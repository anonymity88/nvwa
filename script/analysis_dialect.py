import os
import json
import sys

# 添加 generate 目录到模块搜索路径中
sys.path.insert(0, 'generate')

# script/analysis_dialect.py
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + "/..")
from generate.IR_analysis import IRAnalysis


def process_mlir_directory(directory_path):
    """
    递归遍历目录中的所有 .mlir 文件，统计方言和操作的总数
    """
    dialects = {}
    
    # 遍历目录及其所有子目录
    for root, _, files in os.walk(directory_path):
        for filename in files:
            if filename.endswith(".mlir"):
                file_path = os.path.join(root, filename)
                
                # 读取文件内容
                with open(file_path, 'r') as file:
                    content = file.read()
                
                # 分析IR中的方言和操作
                json_result = IRAnalysis(content)
                data = json.loads(json_result)  # 将返回的JSON字符串转为字典
                
                # 统计方言和操作
                for dialect, ops in data.items():
                    if dialect not in dialects:
                        dialects[dialect] = set()
                    dialects[dialect].update(ops)
    
    # 计算方言总数和操作总数
    dialect_count = len(dialects)
    operation_count = sum(len(ops) for ops in dialects.values())
    
    # 输出结果
    output = {
        "dialects": {dialect: list(ops) for dialect, ops in dialects.items()},
        "total_dialects": dialect_count,
        "total_ops": operation_count
    }
    
    # 输出到JSON文件
    output_file = os.path.join(directory_path, "summary_result.json")
    with open(output_file, 'w') as outfile:
        json.dump(output, outfile, indent=4)
    
    print(f"Summary JSON file has been written to: {output_file}")
    print(f"Total dialects: {dialect_count}")
    print(f"Total operations: {operation_count}")


# 主函数，执行程序
if __name__ == "__main__":
    directory = "/home/llm/official_IRs/Dialect"
    process_mlir_directory(directory)
