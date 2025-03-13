import sys
import re
import json
import os
from collections import defaultdict

sys.path.append('../')
# from utils import *

#分析IR中的方言和算子，保存为json
def IRAnalysis(content):
    # 所有方言的集合
    dialectSet = {"acc", "affine", "amdgpu", "amx", "arith", "arm_neon", "arm_sve", "arm_sme",
            "async", "bufferization", "cf", "complex", "dlti", "emitc", "func", "gpu",
            "index", "irdl", "linalg", "llvm", "math", "memref", "mesh", "ml_program", 
            "mpi", "nvgpu", "nvvm", "omp", "pdl_interp", "pdl", "polynomial", "ptr", "quant", 
            "rocdl", "scf", "shape", "sparse_tensor", "tensor", "ub", "vcix", "vector", 
            "x86vector","xegpu", "builtin", "spirv", "tosa", "transform", "openacc"}


    # 读取IR使用的方言，放入diaList
    diaList = []
    for dialect in dialectSet:
        if dialect + '.' in content:
            diaList.append(dialect)

    # 读取每一个IR使用的op,放入dia_dict
    dia_dict = {}
    for dialect in diaList:
        dia_dict[dialect] = []
        ops = re.findall(dialect + r'\.\w+', content)
        opNameSet = set()
        for op in ops:
            opNameSet.add(op)
        for opName in opNameSet:
            dia_dict[dialect].append(opName)

    # 转json
    json_result = json.dumps(dia_dict, indent=4)
    return json_result



def analyze_mlir_string(mlir_string):

    # Define regex patterns for tensor, vector, and memref
    patterns = {
        'tensor': r'tensor<[^>]*>',
        'vector': r'vector<[^>]*>',
        'memref': r'memref<[^>]*>',
        'complex': r'memref<[^>]*>',
        'array': r'memref<[^>]*>'
    }
    
    # Dictionary to store counts
    type_counts = defaultdict(int)
    
    # Count matches for each data type
    for type_name, pattern in patterns.items():
        matches = re.findall(pattern, mlir_string)
        if matches:
            type_counts[type_name] += len(matches)
    print(type_counts)
    # Calculate data type count and total count
    data_type_count = len(type_counts)  # Number of distinct data types
    total_count = sum(type_counts.values())  # Total occurrences

    return data_type_count, total_count



def compute_complexity(file_path):

    # 读取 MLIR 文件内容
    with open(file_path, 'r') as f:
        mlir = f.read()

    with open(file_path, 'r') as f:
        lines = f.readlines()
    
    combined_lines = []

    for line in lines:
        # 跳过空行和注释行
        if line.strip() == "":
            continue
        if line.startswith("// //"):
            continue
        elif line.startswith("//"):
            continue
        else:
            combined_lines.append(line)

    code = ''.join(combined_lines)

    # 分析 IR 的数据类型数量
    data_type_count, total_count = analyze_mlir_string(code)  # 假定 analyze_mlir_string 函数已定义
    print(data_type_count)
    print(total_count)

    # 分析方言和操作
    dialect_ops = IRAnalysis(code)  # 假定 IRAnalysis 函数已定义
    dialect_ops = json.loads(dialect_ops)
    print(dialect_ops)

    # 计算复杂度
    dialect_count = len(dialect_ops)
    op_count = sum(len(ops) for ops in dialect_ops.values())
    complexity = pow(dialect_count * op_count, data_type_count) / len(mlir)

    print(dialect_count)
    print(op_count)
    print(data_type_count)
    print(len(mlir))
    print(complexity)

    # 确保 complexity.json 文件路径正确
    folder_path = os.path.dirname(file_path)
    complexity_file = os.path.join(folder_path, "complexity.json")

    if os.path.exists(complexity_file):
        with open(complexity_file, 'r') as json_file:
            results = json.load(json_file)
    else:
        results = []

    # 更新或添加复杂度结果
    file_name = os.path.basename(file_path)
    updated = False
    for entry in results:
        if entry["file_name"] == file_name:
            entry["complexity"] = complexity
            updated = True
            break

    if not updated:
        results.append({"file_name": file_name, "complexity": complexity})

    # 按复杂度从大到小排序，确保整体对象移动
    results.sort(key=lambda x: x["complexity"], reverse=True)

    # 将结果保存回 complexity.json 文件
    with open(complexity_file, 'w') as json_file:
        json.dump(results, json_file, indent=4)

    print(f"Updated complexity for {file_name} in {complexity_file}")



def process_folder(folder_path):
    """
    Processes all .mlir files in the folder by computing their complexity.

    Parameters:
        folder_path (str): Path to the folder containing .mlir files.

    Returns:
        None
    """

    # Path to complexity.json
    complexity_file = os.path.join(folder_path, "complexity.json")

    # If complexity.json does not exist, create an empty JSON file
    if not os.path.exists(complexity_file):
        print(f"Creating empty complexity.json in {folder_path}...")
        with open(complexity_file, 'w') as json_file:
            json.dump([], json_file)


    # Traverse all .mlir files in the folder
    for file_name in os.listdir(folder_path):
        if file_name.endswith('.mlir'):
            file_path = os.path.join(folder_path, file_name)
            compute_complexity(file_path)

    print(f"Processing completed for folder: {folder_path}")


def select_by_complexity(folder_path):
    """
    Selects the top 3 .mlir files by complexity from complexity.json in the given folder.
    If complexity.json doesn't exist, compute complexity for all .mlir files in the folder and update it.

    Parameters:
        folder_path (str): Path to the folder containing .mlir files and complexity.json.

    Returns:
        list: A list of up to 3 full file paths to the .mlir files, sorted by complexity.
    """
    complexity_file = os.path.join(folder_path, "complexity.json")

    # If complexity.json does not exist, compute complexity for all .mlir files
    if not os.path.exists(complexity_file):
        print(f"complexity.json not found in {folder_path}. Computing complexity for all .mlir files...")
        process_folder(folder_path)

    # Load complexity.json
    with open(complexity_file, 'r') as json_file:
        results = json.load(json_file)

    # Get the top 3 .mlir files by complexity
    top_files = results[:min(3, len(results))]  # Handles cases with fewer than 3 entries

    # Combine file names with folder path
    selected_files = [os.path.join(folder_path, entry["file_name"]) for entry in top_files]

    return selected_files




if __name__ == "__main__":

    folder_path = "/home/llm/generate_results/1121"  
    # Traverse all .mlir files in the folder
    for file_name in os.listdir(folder_path):
        if file_name.endswith('.mlir'):
            file_path = os.path.join(folder_path, file_name)
            compute_complexity(file_path)

    print(f"Processing completed for folder: {folder_path}")


