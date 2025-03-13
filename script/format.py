import os
import subprocess
import json

# 定义目标目录
directory = "/home/llm/test/"

# 定义输出文件路径
output_file = "./data/finetuning0409.json"

#计数获取的数据总数
count = 0

# 遍历目录中的所有 .mlir 文件
with open(output_file, "w") as f:
    f.write('[\n')  # 写入 JSON 数组的起始括号

for filename in os.listdir(directory):
    if filename.endswith(".mlir"):
        file_path = os.path.join(directory, filename)
        
        # 提取 pass
        with open(file_path, "r") as file:
            passes = ""
            last_line = file.readlines()[-1]
            passes = last_line.replace('//   mlir-opt', '')

        # 运行 mlir-opt 命令，获取返回码
        cmd = "mlir-opt " + file_path + " " + passes
        print(cmd)
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)        
        # result = subprocess.run(cmd, capture_output=True, text=True)
        return_code = result.returncode
        
        #如果有问题，则打印错误信息
        if return_code != 0:    
            print(return_code)
            print(result.stdout)
        
        # 如果返回码为0，则将信息写入文件
        else:
            count += 1
            # 提取 IRs 的内容（去除最后一行）
            with open(file_path, "r") as file:
                IRs = file.readlines()[:-1]  # 逐行读取，并且不包括最后一行
        
            
            # 将 IRs 的内容转换为单个字符串，并转义特殊字符
            IRs = ''.join(IRs)
            IRs = json.dumps(IRs)

            # 转义字段内容中的双引号
            IRs = IRs.replace('"', '\\"')
            passes = passes.replace('"', '\\"')
            
            
            # 写入 finetuning0409.jsonl 文件
            with open(output_file, "a") as f:
                f.write('\t{{\n\t\t"IRs": "{}",\n\t\t"passes": "{}"\n\t}}'.format(IRs, passes))
                if count > 0:
                    f.write(',')  # 添加逗号，除了第一个对象外都在前面添加逗号
                f.write('\n')

# 在循环结束后写入 JSON 数组的结束括号
with open(output_file, "a") as f:
    f.write(']\n')

print(f"共获得正确的IR与pass{count}对")
