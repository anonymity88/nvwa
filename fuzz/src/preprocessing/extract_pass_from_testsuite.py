import re

import os

def extract_pass(original,all_pass):
    # 假定的命令行字符串
    # original = "// RUN: mlir-opt %s -split-input-file -affine-data-copy-generate=\"generate-dma=false fast-mem-space=0 skip-non-unit-stride-loops\""

    #根据-提取pass名称
    pattern = r'-(\S+=".*?")'
    matches = re.findall(pattern, original)
    # print(matches)


    pattern = r'-(\S+)'
    matches1 = re.findall(pattern, original)
    # print(matches)

    #pass处理
    new_list2 = [item for item in matches1 if not any(item in element for element in matches)]
    new_list3 = [item for item in new_list2 if item != "opt" and item != "o" and
                 item != "S" and item != "f" and item != "e" and item != "o=/dev/null"  ]


    new_list4 = matches + new_list3
    # pass_list = ['-' + item for item in new_list4]

    pass_list = [item for item in new_list4 if not any(item in element for element in all_pass)]

    return pass_list


def find_mlir_files(directory):
    mlir_files = []
    # os.walk遍历目录和子目录
    for root, dirs, files in os.walk(directory):
        for file in files:
            # 检查文件后缀是否为.mlir
            if file.endswith('.mlir'):
                # 将文件的完整路径添加到列表中
                mlir_files.append(os.path.join(root, file))
    return mlir_files


if __name__ == '__main__':
    # 指定要搜索的目录
    search_directory = '/home/ty/llvm-project'
    # 调用函数并打印结果
    mlir_files = find_mlir_files(search_directory)
    all_pass = []
    i = 0
    for mlir_file in mlir_files:
        print(mlir_file)
        onefile_pass = []
        with open(mlir_file, 'r') as file:
            content =  file.readlines()

        # print(content)

        run_commands = [item for item in content if item.startswith("// RUN")]
        for cmd in run_commands:
            cmd = cmd.split("FileCheck")[0]
            print(cmd)
            pass_list = extract_pass(cmd,all_pass)
            print(pass_list)
            onefile_pass.extend(pass_list)

        all_pass.extend(onefile_pass)
    print(all_pass)
    all_pass_str = '\n'.join(all_pass)

    target_file = r"/conf/test_pass.txt"
    with open(target_file, 'w') as file:
        file.write(all_pass_str)

        





