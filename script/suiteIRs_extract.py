import os
import subprocess
import re
import json

def extract_IRs(filepath):
    IRs = []
    IR = ""
    Affine = ""
    current_line = ""
    next_line = ""
    with open(filepath, "r") as file:
        lines = file.readlines()
        for line in lines:
            next_line = line
            if current_line.strip().startswith("return"):
                IR = Affine + IR + current_line + "}"
                IRs.append(IR)
                IR = ""
                Affine = ""
            elif current_line.startswith("  }"):
                if next_line.startswith("}"):
                    IR = Affine + IR + current_line + next_line
                    IRs.append(IR)
                    IR = ""
                    Affine = ""
                else:
                    IR += current_line
            elif current_line.strip().startswith("//") or current_line.startswith("\n"):
                current_line = line
                continue
            elif current_line.startswith("}") or current_line.strip().startswith("return"):
                if IR != "":
                    IR += current_line
            elif current_line.startswith("#"):
                Affine += current_line
            else:
                IR += current_line
            current_line = line
    return IRs

def IRAnalysis(content):
    dialectSet = {"acc", "affine", "amdgpu", "amx", "arith", "arm_neon", "arm_sve", "arm_sme",
                  "async", "bufferization", "cf", "complex", "dlti", "emitc", "func", "gpu",
                  "index", "irdl", "linalg", "llvm", "math", "memref", "mesh", "ml_program", 
                  "mpi", "nvgpu", "nvvm", "omp", "pdl_interp", "pdl", "polynomial", "ptr", "quant", 
                  "rocdl", "scf", "shape", "sparse_tensor", "tensor", "ub", "vcix", "vector", 
                  "x86vector", "xegpu", "builtin", "spirv", "tosa", "transform"}

    diaList = []
    for dialect in dialectSet:
        if dialect + '.' in content:
            diaList.append(dialect)

    dia_dict = {}
    for dialect in diaList:
        dia_dict[dialect] = []
        ops = re.findall(dialect + r'\.\w+', content)
        opNameSet = set(ops)
        dia_dict[dialect] = list(opNameSet)

    # 转换为JSON格式
    json_result = json.dumps(dia_dict, indent=4)
    return json_result

def combine_and_write(file, IRs, output_dir):
    i = 1
    for IR in enumerate(IRs):
        contents = str(IR[1])
        file_name = f"{file}_{i}.mlir"
        i += 1
        file_path = os.path.join(output_dir, file_name)

        # 写入IR内容到临时文件test.mlir
        with open("test.mlir", "w") as f:
            f.write(contents)

        # 使用mlir-opt检查IR文件
        result = subprocess.run(['mlir-opt', 'test.mlir'], capture_output=True)

        # 如果返回码不为0，则忽略文件
        if result.returncode != 0:
            print(f"Error in {file_name}. Ignoring the file.")
            continue

        # 通过IRAnalysis函数分析IR
        json_result = IRAnalysis(contents)

        # 解析JSON结果
        parsed_json = json.loads(json_result)

        # 如果解析后的字典为空，跳过处理
        if not parsed_json:
            print(f"No dialects or ops found in {file_name}. Skipping.")
            continue

        # 统计哪个方言的列表最长，选择那个方言
        max_dialect = max(parsed_json, key=lambda k: len(parsed_json[k]))

        # 创建保存IR的目录
        dialect_dir = os.path.join(output_dir, max_dialect)
        if not os.path.exists(dialect_dir):
            os.makedirs(dialect_dir)

        # 保存IR文件
        ir_file = os.path.join(dialect_dir, f"{file_name}_{i}.mlir")
        with open(ir_file, "w") as ir_f:
            ir_f.write(contents)

# 新增的函数：处理给定目录及其子目录中的所有.mlir文件
def process_directory(base_directory, output_base_dir):
    if not os.path.exists(output_base_dir):
        os.makedirs(output_base_dir)

    for sub_dir in os.listdir(base_directory):
        sub_dir_path = os.path.join(base_directory, sub_dir)
        if os.path.isdir(sub_dir_path):
            lower_sub_dir = sub_dir.lower()
            output_dir = os.path.join(output_base_dir, lower_sub_dir)
            if not os.path.exists(output_dir):
                os.makedirs(output_dir)

            for root, dirs, files in os.walk(sub_dir_path):
                for file_name in files:
                    if file_name.endswith(".mlir"):
                        path = os.path.join(root, file_name)
                        IRs = extract_IRs(path)
                        combine_and_write(file_name, IRs, output_dir)

def process_mlir_files(base_directory, output_base_dir):
    if not os.path.exists(output_base_dir):
        os.makedirs(output_base_dir)

    for sub_dir in os.listdir(base_directory):
        sub_dir_path = os.path.join(base_directory, sub_dir)
        if os.path.isdir(sub_dir_path):
            # lower_sub_dir = sub_dir.lower()
            output_dir = output_base_dir
            if not os.path.exists(output_dir):
                os.makedirs(output_dir)

            for root, dirs, files in os.walk(sub_dir_path):
                for file_name in files:
                    if file_name.endswith(".mlir"):
                        path = os.path.join(root, file_name)
                        IRs = extract_IRs(path)
                        combine_and_write(file_name, IRs, output_dir)


if __name__ == "__main__":
    # output_base_dir = "official_IRs/Dialect"
    # base_directory = "llvm-project/mlir/test/Dialect/"
    # process_mlir_files(base_directory, output_base_dir)

    # 调用新函数处理指定目录
    new_base_directory = "llvm-project/"
    new_output_base_dir = "official_IRs/Dialect"
    process_directory(new_base_directory, new_output_base_dir)
