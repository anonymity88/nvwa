import openai
import subprocess
import re
import os
import random
from collections import Counter
from datetime import datetime
import IR_analysis
import json

os.environ["http_proxy"] = "http://10.15.22.40:7890"
os.environ["https_proxy"] = "http://10.15.22.40:7890"

# 设置 OPENAI_API_KEY 环境变量
os.environ["OPENAI_API_KEY"] = "sk-4sF6EtYk06pNxnzmB59832Fe2a514e25B51c4aCd29A3Cd3c"
# 设置 OPENAI_BASE_URL 环境变量
os.environ["OPENAI_BASE_URL"] = "https://api.xiaoai.plus/v1"

def get_gpt_response(messages, model="gpt-4o-mini",temperature=0.4):
    response = openai.chat.completions.create(
        model=model,
        messages=messages,
        temperature=temperature,  # 添加温度参数
        # top_p=1.0,
        # presence_penalty=0.0,
        # frequency_penalty=0.0,
        timeout=120
    )
    return response.choices[0].message.content


def extract_mlir_ir(response):
    # 使用正则表达式提取MLIR IR代码块
    ir_match = re.search(r'```mlir\n(.*?)```', response, re.DOTALL)
    if ir_match:
        return ir_match.group(1).strip()
    return None


def run_mlir_opt(file_path):
    result = subprocess.run(["mlir-opt", file_path], capture_output=True, text=True)
    return result.returncode, result.stderr


def get_next_file_path(directory, extension):
    existing_files = os.listdir(directory)
    # 过滤符合扩展名和正则匹配的文件
    existing_files = [f for f in existing_files if f.endswith(extension) and re.match(r'^\d+', f)]
    # 提取以数字开头的部分并转换为整数
    existing_numbers = [int(re.match(r'^(\d+)', f).group(1)) for f in existing_files]
    # 找到下一个编号
    next_number = max(existing_numbers, default=0) + 1
    return os.path.join(directory, f"{next_number}{extension}")



def has_single_module(mlir_ir: str) -> bool:

    # 查找所有的 module 关键字
    module_count = mlir_ir.count('module')

    # 如果 module 关键字的数量为 1 则返回 True，否则返回 False
    return module_count == 1


#用于判断多OP生成时是否将所有OP包括在一个func中，或者func之间有调用关系
def Iscombined(mlir_ir: str) -> bool:

    #用于判断生成IR之间的调用关系
    # 使用正则表达式匹配所有的@XXX
    matches = re.findall(r'@(\w+)', mlir_ir)
    
    # 计算每个@XXX的出现次数
    count = Counter(matches)

    # 统计所有@XXX的总数
    total_count = sum(count.values()) 
    if( total_count > 1 ):
        # 获取总的@XXX数量（不包括@main）
        total_non_main = sum(1 for key in count if key != 'main')
        
        # 获取出现次数大于等于2的@XXX的数量
        count_gte_2 = sum(1 for key, value in count.items() if key != 'main' and value >= 2)
        
        # 计算比例
        if total_non_main > 0:
            ratio = count_gte_2 / total_non_main
        else:
            ratio = 0
        
        # 检查是否只含有一个@main或一个@XXX
        if len(count) == 1 and ('main' in count or len(count) == 1):
            return True
        
        # 检查是否含有多个@XXX，且除了@main外的每个@XXX出现次数大于等于2的比例是否超过50%
        if total_non_main > 0 and ratio > 0.5:

            return True
        
        print("The proportion of called functions is no more than 50%.")
        # 其他情况返回False
        return False

    # 查找所有的 module 关键字
    module_count = mlir_ir.count('module')
    print(f"The IR has {module_count} modules")

    # 如果 module 关键字的数量为 1 则返回 True，否则返回 False
    return module_count == 1


#用于判断生成IR之间的调用关系
def contains_required_op(mlir_ir: str) -> bool:
    # 使用正则表达式匹配所有的@XXX
    matches = re.findall(r'@(\w+)', mlir_ir)
    
    # 计算每个@XXX的出现次数
    count = Counter(matches)

    # 获取总的@XXX数量（不包括@main）
    total_non_main = sum(1 for key in count if key != 'main')
    
    # 获取出现次数大于等于2的@XXX的数量
    count_gte_2 = sum(1 for key, value in count.items() if key != 'main' and value >= 2)
    
    # 计算比例
    if total_non_main > 0:
        ratio = count_gte_2 / total_non_main
    else:
        ratio = 0
    
    # 检查是否只含有一个@main或一个@XXX
    if len(count) == 1 and ('main' in count or len(count) == 1):
        return True
    
    # 检查是否含有多个@XXX，且除了@main外的每个@XXX出现次数大于等于2的比例是否超过50%
    if total_non_main > 0 and ratio > 0.5:
        return True
    
    print("The proportion of called functions is no more than 50%.")
    # 其他情况返回False
    return False


def fill_text_with_files(directory, dialect, IRscount, type, origin_mlir):
    # 读取模板文本
    with open(f"prompt/prompt_{type}.txt", 'r') as template_file:
        template_text = template_file.read()

    # 获取目录中的所有mlir文件
    txt_files = [f for f in os.listdir(directory) if f.endswith('.mlir')]

    # 随机选择文件
    selected_files = random.sample(txt_files, IRscount)

    # 提取文件名（去掉后缀 ".txt"）
    file_names = [os.path.splitext(f)[0] for f in selected_files]

    file_names_str = ", ".join(file_names)

    # 拼接文件的内容
    file_contents = []
    for file in selected_files:
        with open(os.path.join(directory, file), 'r') as f:
            file_contents.append(f.read())
    combined_content = "\n".join(file_contents)

    combined_content =  origin_mlir + combined_content
    
    # 去掉combined_content中所有以"//"开头的行
    combined_content = "\n".join([line for line in combined_content.splitlines() if not line.strip().startswith("//")])

    # 用文件名填充"$$"位置
    filled_text = template_text.replace("$$", file_names_str)

    # 用拼接的内容填充"@@@@"
    filled_text = filled_text.replace("@@@@", combined_content)

    #选择并填充examples

    filled_text = fill_Examples_mutate(filled_text, dialect, type)

    

    # 将结果输出
    with open(f"prompt/prompt_{type}1.txt", 'w') as output_file:
        output_file.write(filled_text)

    #输出挑选的OP名
    print(file_names_str)
    print(file_names)

    # 读取 prompt2.txt 文件并替换其中的 $$
    with open(f"prompt/prompt_{type}_modify.txt", 'r') as prompt2_file:
        prompt2_text = prompt2_file.read()
    
    # 替换 prompt2.txt 中的 $$ 为 filled_text 的内容
    updated_prompt2_text = prompt2_text.replace("$$", file_names_str)
    
    
    with open(f"prompt/prompt_{type}_modify1.txt", 'w') as output_file:
        output_file.write(updated_prompt2_text)
    with open(f"prompt/prompt_{type}_file_names.txt", 'w') as output_file:
        output_file.write(str(file_names))
    with open(f"prompt/prompt_{type}_combined_content.txt", 'w') as output_file:
        output_file.write(combined_content)


    return file_names, file_names_str, filled_text, updated_prompt2_text, combined_content



#多OP生成和变异填充示例
def fill_Examples_mutate(filled_text, Dialect, type):

    # 获取文件目录
    dir_path = f"/home/llm/generate_results/{type}_IRs/{Dialect}"
    
    # 检查目录是否存在，如果不存在则返回原始的 filled_text
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
        print(f"Directory {dir_path} does not exist.")
        return filled_text
    
    # 随机挑选文件
    # 列出目录下的 .mlir 文件
    files = [f for f in os.listdir(dir_path) 
            if os.path.isfile(os.path.join(dir_path, f)) and f.endswith(".mlir")]
    # 随机选取最多 3 个文件
    # selected_files = random.sample(files, min(3, len(files)))

    # 基于复杂度挑选文件
    selected_files = IR_analysis.select_by_complexity(dir_path)
    
    # 用于存储IRs和combined内容的占位符替换结果
    IRs_combined_pairs = []
    
    # 处理选中的文件
    for i, file in enumerate(selected_files):
        with open(os.path.join(dir_path, file), 'r') as f:
            lines = f.readlines()

        # 分离出以"//"开头的行作为IRs，其他行作为combined
        IRs_lines = []
        combined_lines = []

        for line in lines:
            # 保持缩进和行尾空格，不使用strip()，只跳过完全为空的行
            if line.strip() == "":  
                continue

            if line.startswith("// //"):
                continue
           # 严格判断是否以"//"开头
            elif line.startswith("//"):
                IRs_lines.append(line[2:])  # 从索引2开始去掉"//"  
            else:
                # 非"//"开头的行作为combined_lines
                combined_lines.append(line)


        # 组合IRs和combined内容
        IRs = ''.join(IRs_lines)
        combined = ''.join(combined_lines)
        
        # #一步生成，分析选取的示例
        # results = IR_analysis.IRAnalysis(combined)
        # results = json.loads(results)  # 将返回的JSON字符串转为字典
        # # 找到最长的列表及对应的dialect
        # dialect = max(results, key=lambda k: len(results[k]))
        # # 初始化一个空字符串来存储所有文件内容
        # specification = ""
        # # 循环处理最长列表中的每个 item
        # for item in results[dialect]:
        #     # 生成文件路径
        #     file_path = f"OPs/{dialect}/{item}.txt"
            
        #     # 检查文件是否存在
        #     if os.path.exists(file_path):
        #         # 如果文件存在，读取内容并添加到 specification
        #         with open(file_path, 'r') as file:
        #             specification += file.read()
        #     else:
        #         # 如果文件不存在，打印提示信息
        #         print(f"文件 {file_path} 不存在，跳过。")
        
        
        # 添加到替换列表
        IRs_combined_pairs.append((IRs, combined))
    
    # 用于替换的占位符
    placeholders = ["$IRs1$", "$combined1$", "$IRs2$", "$combined2$", "$IRs3$", "$combined3$"]
    
    # 替换占位符，如果不足3个文件，剩余部分替换为空字符串
    for i, (IRs, combined) in enumerate(IRs_combined_pairs):
        filled_text = filled_text.replace(placeholders[2*i], IRs).replace(placeholders[2*i+1], combined)
    
    # 对于没有选到的文件，替换为空字符串
    for i in range(len(IRs_combined_pairs), 3):
        filled_text = filled_text.replace(placeholders[2*i], "").replace(placeholders[2*i+1], "")
    
    return filled_text


#单OP生成填充示例
def fill_Examples_generate(filled_text, Dialect):
    # 获取文件目录
    dir_path = f"generate_results/Single_OP/{Dialect}"
    
    # 检查目录是否存在
    if not os.path.exists(dir_path):
        print(f"Directory {dir_path} does not exist.")
        return filled_text
    
    # 随机挑选文件
    # 列出目录下的 .mlir 文件
    # files = [f for f in os.listdir(dir_path) 
    #         if os.path.isfile(os.path.join(dir_path, f)) and f.endswith(".mlir")]
    # # 随机选取最多 3 个文件
    # selected_files = random.sample(files, min(3, len(files)))

    # 基于复杂度挑选文件
    selected_files = IR_analysis.select_by_complexity(dir_path)
    
    # 用于存储替换的内容
    replacements = []
    
    # 处理选中的文件
    for i, file in enumerate(selected_files):
        # file_path = os.path.join(dir_path, file)
        
        # 读取文件内容
        with open(file, 'r') as f:
            file_content = f.read()
        
        file_name = os.path.basename(file)
        # 读取文件名（去除后缀）
        file_name = os.path.splitext(file_name)[0]
        
        # 查找同名定义文件
        op_define_path = os.path.join(f"OPs/{Dialect}", f"{file_name}.txt")  # 假设定义文件是.txt格式
        op_define_content = ""
        if os.path.exists(op_define_path):
            with open(op_define_path, 'r') as f:
                op_define_content = f.read()
        
        # 添加到替换列表
        replacements.append((file_name, op_define_content, file_content))
    
    # 用于替换的占位符
    placeholders = ["$OP1$", "$OPdefine1$", "$result1$", "$OP2$", "$OPdefine2$", "$result2$", "$OP3$", "$OPdefine3$", "$result3$"]
    
    # 替换占位符
    for i in range(len(replacements)):
        file_name, op_define_content, result_content = replacements[i]
        filled_text = filled_text.replace(placeholders[3*i], file_name)
        filled_text = filled_text.replace(placeholders[3*i+1], op_define_content)
        filled_text = filled_text.replace(placeholders[3*i+2], result_content)
    
    # 对于没有选到的文件，替换为空字符串
    for i in range(len(replacements), 3):
        filled_text = filled_text.replace(placeholders[3*i], "").replace(placeholders[3*i+1], "").replace(placeholders[3*i+2], "")
    
    return filled_text