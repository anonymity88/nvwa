import os

def extract_opts(filepath):
    opts = []
    with open(filepath, "r") as file:
        lines = file.readlines()
        iterator = iter(lines)
        for line in iterator:
            if line.startswith("// RUN: "):
                opt = line.strip()[8:]
                opt = opt.split('|')[0]  # 去除 '|' 后的内容
                opt = opt.replace('%s', '')  # 去除 '%s'
                opts.append(opt)
    print(opts)
    return opts

def extract_IRs(filepath):
    IRs = []
    IR = ""
    Affine = ""
    current_line = ""
    next_line = ""
    with open(filepath, "r") as file:
        lines = file.readlines()
        # print(lines)
        iterator = iter(lines)
        for line in lines:
            next_line  = line
            # print(next_line)
            # #判断此行是否为一个IR开始的行
            # if line.startswith("func.func") or line.startswith("builtin.module") or line.startswith("module"):
            #     if not IR :#IR为空，则放入
            #         IR += line
            #     else:#IR不为空，则表示上一个IR结束
            #         IRs.append(IR)
            #         IR = ""
            #         IR += line
            
            #判断此行是否为一个IR结束的行
            #strip()用于去除字符串两端的空白字符（包括空格、制表符 \t、换行符 \n 等）,它不会修改原始字符串，而是返回一个新的字符串。
            if current_line.strip().startswith("return"):
                IR  = Affine + IR + current_line + "}"
                IRs.append(IR)
                IR = ""
                Affine = ""
            
             #判断此行是否为一个IR结束的行
            elif current_line.startswith("  }"):
    
                if next_line.startswith("}"):
                    IR  = Affine + IR + current_line + next_line
                    IRs.append(IR)
                    IR = ""
                    Affine = ""
                else:
                    IR += current_line
                    
            
            #判断一行是否是注释行或者空白行
            elif current_line.strip().startswith("//") or current_line.startswith("\n") :
                current_line = line
                continue
                
            elif current_line.startswith("}") or current_line.strip().startswith("return"):
                if IR != "":
                    IR += current_line
            
            #判断一行是否是仿射定义行
            elif current_line.startswith("#"):
                Affine += current_line
                
            else:
                IR += current_line

            
            current_line = line
            
    print(IRs)
    return IRs

def combine_and_write(file,opts, IRs, output_dir):
    i = 1
    for opt in enumerate(opts):
        for IR in enumerate(IRs):
            # 组合元素
            contents = str(IR[1]) + "\n\n\n//   "+ str(opt[1])

            # 写入文件
            file_name = f"{file}_{i}.mlir"
            i += 1
            file_path = os.path.join(output_dir, file_name)
            with open(file_path, "w") as f:
                f.write(contents)

def process_mlir_files(directory,output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    for root, dirs, files in os.walk(directory):
        for file_name in files:
            if file_name.endswith(".mlir"):
                path = os.path.join(root, file_name)
                opts = extract_opts(path)
                IRs = extract_IRs(path)
                
                combine_and_write(file_name, opts, IRs, output_dir)

if __name__ == "__main__":
    output_dir = "/home/llm/official_IR"
    directory = "/home/llm/llvm-project/"
    process_mlir_files(directory,output_dir)



