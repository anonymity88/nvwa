


import os
import sys
import re
import subprocess
import signal
sys.path.append('/home/llm/fuzz/src/utils')
from utils import *

import os


def runMLIR(cmd):
    stderr = ""
    pro = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8",preexec_fn=os.setsid)
    try:
        stdout, stderr = pro.communicate(timeout=20)
        return_code = pro.returncode
    except subprocess.TimeoutExpired:
        os.killpg(pro.pid,signal.SIGTERM)
        return_code = 999
    return stderr,return_code

def extract_pass(original,all_pass):
    # 假定的命令行字符串
    # original = "// RUN:   --pass-pipeline='builtin.module(func.func(convert-arith-to-amdgpu{chipset=gfx940 saturate-fp8-truncf=true}))' --split"

    pattern = r'-(\S+=".*?")'
    matches = re.findall(pattern, original)
    if matches==[]:
        pattern = r"-(\S+='.*?')"
        matches = re.findall(pattern, original)
    # print(matches)

    pattern = r'-(\S+)'
    matches1 = re.findall(pattern, original)
    # print(matches)

    #pass处理
    new_list2 = [item for item in matches1 if not any(item in element for element in matches)]
    new_list3_ = [item for item in new_list2 if len(item) > 1]

    # 过滤掉单个字母的字符串
    new_list3 = matches + new_list3_

    new_list4 = [item for item in new_list3 if item != "opt" and item != "o=/dev/null"  ]
    #加上-
    new_list5 = ['-' + item for item in new_list4 if not item.startswith('-')]

    print(new_list5)
    pass_list = [item for item in new_list5 if not any(item in element for element in all_pass)]

    return pass_list

def find_mlir_files(directory):
    mlir_files = []
    # os.walk遍历目录和子目录
    for root, dirs, files in os.walk(directory):
        for file in files:
            # 检查文件后缀是否为.mlir
            if file.endswith('.mlir'):
                print(file)
                # 将文件的完整路径添加到列表中
                mlir_files.append(os.path.join(root, file))
    return mlir_files
def extract_pass_from_testsuite(search_directory):
    # 调用函数并打印结果
    mlir_files = find_mlir_files(search_directory)
    all_pass = []
    i = 0
    for mlir_file in mlir_files:
        print(mlir_file)
        onefile_pass = []
        with open(mlir_file, 'r') as file:
            content = file.readlines()

        # print(content)
        run_commands = [item for item in content if item.startswith("// RUN")]
        for cmd in run_commands:
            # cmd = cmd.split("FileCheck")[0]
            pass_list = extract_pass(cmd, all_pass)
            onefile_pass.extend(pass_list)

        all_pass.extend(onefile_pass)
    print(all_pass)
    all_pass_str = '\n'.join(all_pass)
    return all_pass_str



# 处理mlir-opt中的pass
def preprocessing(content,mlir_opt_path,empty_mlir):  #pass预处理  根据--提取pass
    passe_list = []
    i = 0
    for line in content:
        line = line.strip()
        if line.startswith('-'):
            i = i + 1
            pass_ = line.split(" ")[0]
            if "emit-bytecode" in pass_:
                continue
            cmd = "{} {} {}".format(mlir_opt_path,empty_mlir,pass_)
            print(i,'/',len(content))
            print(cmd)
            stderr,recode = runMLIR(cmd)
            print(stderr)
            if recode !=0:
                if "run on 'builtin.module'" in stderr:
                    pass_ = "--pass-pipeline=\"builtin.module(func.func({}))\"".format(pass_.lstrip("--"))
                    passe_list.append(pass_)
            else:
                passe_list.append(pass_)

    print("#all pass : ",str(i))
    print("#valid pass : ", len(passe_list))

    passe_str = '\n'.join(passe_list)
    return passe_str


#合并测试套件中提取的pass（带参数）+ mlir-opt提取的pass（不带参数）
def merge(content,content1):
    content = [s.lstrip('-') for s in content]
    content1 = [s.lstrip('-') for s in content1]

    content = ['--'+s for s in content]
    content1 = ['--'+s for s in content1]

    all_pass = content+ content1
    unique_list = list(set(all_pass))



    # 将列表转换为集合并求交集
    common_elements = set(content) & set(content1)

    print("repeat",len(common_elements))
    print("total",len(all_pass))
    print("unique",len(unique_list))

    unique_list.sort(reverse=True)
    return unique_list


if __name__ == '__main__':
    # =========修改路径========
    # 指定mlir-opt命令的路径/home/llm/llvm-project
    mlir_opt_path = "/home/llm/llvm-project/build/bin/mlir-opt"
    # 指定要搜索的MLIR测试套件路径，从中提取带参数的pass
    search_directory = '/home/llm/llvm-project'
    # search_directory = "/home/workdir/llm-tracer/fuzz_tool/src/preprocessing/test"
    empty_mlir = '/home/llm/test/empty.mlir'
    # ========================

    # 1.保存 mlit-opt --help打印的所有pass
    raw_file = "./mlir_opt.txt"
    target_file = r"./mlir_opt1.txt"
    cmd = "{} --help > {}".format(mlir_opt_path, raw_file)
    os.system(cmd)

    # pass预处理  根据--提取pass
    with open(raw_file, 'r',encoding="utf-8") as f:
        content = f.readlines()
    mlir_opt_pass = preprocessing(content,mlir_opt_path,empty_mlir)
    with open(target_file, 'w') as file:
        file.write(mlir_opt_pass)

    # 2.提取测试套件中带参数的pass
    raw_file1 = r"./suite_opt.txt"
    target_file1 = r"./suite_opt1.txt"
    testsuite_pass = extract_pass_from_testsuite(search_directory)
    with open(raw_file1, 'w') as file:
        file.write(testsuite_pass)

    with open(raw_file1, 'r',encoding="utf-8") as f:
        content = f.readlines()
    passe_str = preprocessing(content,mlir_opt_path,empty_mlir) #提取所有pass，并验证
    with open(target_file1, 'w') as f:
        f.write(passe_str)
    #
    # 3.合并带参和不带参的pass list
    merge_file = r"./opts.txt"
    with open(target_file, 'r', encoding="utf-8") as f:
        content = f.readlines()
    with open(target_file1, 'r', encoding="utf-8") as f:
        content1 = f.readlines()
    unique_list = merge(content, content1)
    unique_str = ''.join(unique_list)
    with open(merge_file, 'w') as file:
        file.write(unique_str)






