import os
import json
import random
import argparse
import GPT_genetrate
import GPT_mutate
import generate_utils

import time

base_dir = "generate_results/Single_OP"

base_multi_IRs_dir = "generate_results/multi_IRs"
config_file = "generate/gen_config.json"

gen_total_interaction_times = 0
mut_total_interaction_times = 0
ran_total_interaction_times = 0
gen_times_list =[]
mut_times_list =[]
ran_times_list =[]


# 从json文件中加载方言信息
def load_dialect_config(json_file):
    with open(json_file, 'r') as file:
        date = json.load(file)
    return date['dialects']


# 生成阶段
def generate_stage(dialects, dialect_stats, totol_seeds_count, output_file):
    global gen_total_interaction_times  # 声明使用全局变量
    global gen_times_list
    start_time = time.time()

    # 计算 "gen_weight" 总和
    total_gen_weight = sum( dialect["gen_weight"] for dialect in dialects)

    for dialect_info in dialects:
        
        dialect = dialect_info["name"]
        OPscount = dialect_info["OPscount"]
        requiredOPscount = dialect_info["requiredOPscount"]
        max_retries = dialect_info["max_retries"]
        # max_retries = 10
        model = dialect_info["model"]
        gen_percent = dialect_info["gen_weight"]
        generate_times = totol_seeds_count * gen_percent / total_gen_weight

        gen_times = 0
        gen_count = 0
        generator = GPT_genetrate.Generator(
            dialect=dialect, date=date, OPscount=OPscount,
            requiredOPscount=requiredOPscount, max_retries=max_retries
        )

        # 初始化当前方言的计数器
        dialect_stats[dialect] = 0

        # 生成
        while gen_count < generate_times:
            if gen_times - gen_count >= 5:
                model = "gpt-4o"
            mlir, interaction_times = generator.generate_multi(model)
            gen_times_list.append(interaction_times)
            print(gen_times_list)

            current_time = time.time()
            with open(output_file, "a") as f:
                f.write(str(gen_times_list))
                f.write(f"{current_time - start_time:.2f}\n\n")

            gen_total_interaction_times += interaction_times
            print(gen_total_interaction_times)

            # 如果生成成功
            if mlir:
                gen_count += 1
                # 保存
                file_path = generate_utils.get_next_file_path(result_dir, '.mlir')
                with open(file_path, 'w') as file:
                    file.write(mlir)
            gen_times += 1
            print(f"Dialect: {dialect}, Count: {gen_count}")
        
        # 记录生成次数
        dialect_stats[dialect] = gen_count

    # 最终将统计结果输出到文件
    output_dialect_stats = f"generate_results/{date}/dialect_stats.txt"
    os.makedirs(os.path.dirname(output_dialect_stats), exist_ok=True)

    with open(output_dialect_stats, "w") as f:
        for dialect, count in dialect_stats.items():
            f.write(f"Dialect: {dialect}, Count: {count}\n")

    return dialect_stats


# 变异阶段
def mutate_stage(dialects, dialect_stats, output_file):
    global mut_total_interaction_times  # 声明使用全局变量
    global mut_times_list
    start_time = time.time()

    # 遍历生成的MLIR文件
    for filename in os.listdir(result_dir):
        if filename.endswith(".mlir"): 
            filename = os.path.join(result_dir, filename)
            with open(filename, 'r') as file:
                mlir = file.read()
            mutator = GPT_mutate.MLIRMutator(date=date, IRscount=1)
            dialect = mutator.analyseDialect(mlir)
            print(dialect)

            mut_attempts = 0
            #查找该方言的交互次数
            for dialect_info in dialects:
                if dialect_info["name"] == dialect:
                    mut_attempts = dialect_info["mut_attempts"]
                    break
            
            if mut_attempts == 0:
                mut_attempts = 2

            for attempt in range(mut_attempts):
                # 尝试变异
                mutated_mlir, interaction_times = mutator.mutate(mlir, dialect)
                mut_times_list.append(interaction_times)
                print(mut_times_list)

                current_time = time.time()
                with open(output_file, "a") as f:
                    f.write(str(mut_times_list))
                    f.write(f"{current_time - start_time:.2f}\n\n")

                mut_total_interaction_times += interaction_times
                print(mut_total_interaction_times)

                # 如果变异成功
                if mutated_mlir and mutated_mlir != mlir:
                    # 保存成功变异的MLIR文件
                    new_file_path = generate_utils.get_next_file_path(result_dir, '.mlir')
                    with open(new_file_path, 'w') as file:
                        file.write(mutated_mlir)
                    
                    # 记录生成次数
                    if dialect not in dialect_stats:
                        dialect_stats[dialect] = 1
                    else:
                        dialect_stats[dialect] += 1
                    # 每次更新计数后打印统计结果
                    print(dialect_stats)
                    break  # 成功后退出循环

    # 最终将统计结果输出到文件
    output_dialect_stats = f"generate_results/{date}/dialect_stats.txt"
    os.makedirs(os.path.dirname(output_dialect_stats), exist_ok=True)

    with open(output_dialect_stats, "a") as f:
        for dialect, count in dialect_stats.items():
            f.write(f"Dialect: {dialect}, Count: {count}\n")

    return dialect_stats


# 随机变异阶段，45种方言随机进行测试套件用例的合成变异
def random_mutate_stage(dialect_stats, totol_seeds_count, output_file):
    global ran_total_interaction_times  # 声明使用全局变量
    global ran_times_list
    start_time = time.time()

    # 读取配置文件
    config_path = "generate/mut_config.json"
    with open(config_path, 'r') as f:
        config = json.load(f)
    
    # 从配置中获取单次和双次变异方言
    single_mut_dialects = set(config["single_mut_dialects"])
    double_mut_dialects = set(config["double_mut_dialects"])

    # 创建初始方言列表
    elements = [
        # "affine", "arith", 
        # "bufferization", "complex", "emitc", "linalg", 
        # # "llvm", "math", "memref", "mesh", "ml_program", "nvgpu", "nvvm", "omp", "pdl", 
        # "scf",  
        # "spirv", "tosa"
        
        "acc", "arm_sme",
        "dlti", 
        "llvm", "nvgpu", "nvvm", "omp", "pdl", 
        "polynomial", "ptr", "quant", "sparse_tensor", "ub",
        "x86vector", "builtin", "transform", "openacc"
    ]

    # 初始化控制字典，记录每个方言的变异次数
    dialect_mutation_count = {dialect: 0 for dialect in elements}

    # 创建一个迭代器
    element_iter = iter(elements)

    generate_seeds = len([file for file in os.listdir(result_dir) if file.endswith('.mlir')])
    mutate_times = totol_seeds_count - generate_seeds
    mutator = GPT_mutate.MLIRMutator(IRscount=2)
    count = 0

    while count < mutate_times:
        try:
            # 顺序获取 elements 列表中的下一个元素作为 dialect
            dialect = next(element_iter)
        except StopIteration:
            # 如果元素用完了，重新从头开始迭代
            element_iter = iter(elements)
            dialect = next(element_iter)

        # 检查方言是否已经满足变异次数要求
        if dialect in single_mut_dialects and dialect_mutation_count[dialect] >= 1:
            print(f"Dialect {dialect} has reached its mutation limit (1 time), removing it from iterator.")
            continue  # 跳过该方言

        if dialect in double_mut_dialects and dialect_mutation_count[dialect] >= 2:
            print(f"Dialect {dialect} has reached its mutation limit (2 times), removing it from iterator.")
            continue  # 跳过该方言

        # 检查是否在 generate_results/multi_IRs 目录中的子目录
        dialect_path = os.path.join(base_multi_IRs_dir, dialect)

        if os.path.isdir(dialect_path):  # 如果 dialect 是某个子目录的名字
            # 从该目录中随机选择一个文件
            files = [f for f in os.listdir(dialect_path) if f.endswith('.mlir')]
            if files:
                selected_file = random.choice(files)
                file_path = os.path.join(dialect_path, selected_file)
                
                # 读取文件内容到 origin_mlir
                with open(file_path, 'r') as f:
                    origin_mlir = f.read()
            else:
                origin_mlir = ""
                
        else:
            # 如果 dialect 不是子目录，则传递空字符串
            origin_mlir = ""

        # 调用 mutator.mutate
        mutated_mlir, interaction_times = mutator.mutate(origin_mlir, dialect)
        
        ran_times_list.append(interaction_times)
        print(ran_times_list)
        current_time = time.time()
        with open(output_file, "a") as f:
            f.write(str(ran_times_list))
            f.write(f"{current_time - start_time:.2f}\n\n")
        ran_total_interaction_times += interaction_times

        # 如果随机变异结果不为空，统计随机变异次数
        if mutated_mlir and mutated_mlir != origin_mlir:
            # 保存
            file_path = generate_utils.get_next_file_path(result_dir, '.mlir')
            with open(file_path, 'w') as file:
                file.write(mutated_mlir)
            if dialect not in dialect_stats:
                dialect_stats[dialect] = 0
            dialect_stats[dialect] += 1
            
            # 更新变异计数
            dialect_mutation_count[dialect] += 1
            count += 1

        # 打印随机变异的计数
        print(dialect_stats)

    # 最终将统计结果输出到文件
    output_dialect_stats = f"generate_results/{date}/dialect_stats.txt"
    os.makedirs(os.path.dirname(output_dialect_stats), exist_ok=True)

    with open(output_dialect_stats, "a") as f:
        for dialect, count in dialect_stats.items():
            f.write(f"Dialect: {dialect}, Count: {count}\n")
    
    return dialect_stats


if __name__ == "__main__":
    # 设置参数解析器
    parser = argparse.ArgumentParser(description="Run the generator with specified dialect and mode.")
    parser.add_argument("--opt",  default="MLIRGensyn", choices=["MLIRGensyn", "gen_mut", "mut", "gen"], 
                        help="The mode of operation: 'MLIRGensyn' ,'gen_mut', 'mut', 'gen'.")
    parser.add_argument("--seeds", default=500, 
                        help="Please enter the number of seeds you want to generate")
    parser.add_argument("--date", default="test",  
                        help="Please enter the date")

    
    # 解析参数
    args = parser.parse_args()
    opt = args.opt
    totol_seeds_count = int(args.seeds)
    date = args.date

    # 创建 result_dir，如果不存在
    result_dir = f"generate_results/{date}"
    os.makedirs(result_dir, exist_ok=True)

    # 保存生成日志
    # 确保目标目录存在
    output_dir = f"generate_results/{date}"
    os.makedirs(output_dir, exist_ok=True)
    # 输出文件路径
    output_file = os.path.join(output_dir, "main.log")

    # 创建一个字典来存储每个dialect的计数
    dialect_stats = {}
    dialects = load_dialect_config(config_file)
    log_lines = []  # 用于收集所有日志信息

    if opt == "gen" or opt == "gen_mut" or opt == "MLIRGensyn":
        if opt == "gen":
            generate_times = int( totol_seeds_count )
        if opt == "gen_mut":
            generate_times = int( totol_seeds_count * 0.55 ) #该模式下生成模块的占比，可调整
        if opt == "MLIRGensyn":
            generate_times = int( totol_seeds_count * 0.45 ) #该模式下生成模块的占比，可调整

        # 记录 generate_stage 的执行时间
        start_time = time.time()
        # 执行生成阶段
        dialect_stats = generate_stage(dialects, dialect_stats, generate_times, output_file)
        gen_total_time = time.time() - start_time
        log_lines.append(f"生成阶段执行时间: {gen_total_time:.2f} 秒")

    if opt == "gen_mut" or opt == "MLIRGensyn":
        # 记录 mutate_stage 的执行时间
        start_time = time.time()
        # 执行变异阶段
        dialect_stats = mutate_stage(dialects, dialect_stats, output_file)
        mut_total_time = time.time() - start_time
        log_lines.append(f"变异阶段执行时间: {mut_total_time:.2f} 秒")

    if opt == "mut" or opt == "MLIRGensyn":
        # 记录随机变异阶段的执行时间
        start_time = time.time()
        # 执行测试套件的随机变异
        dialect_stats = random_mutate_stage(dialect_stats, totol_seeds_count, output_file)
        ran_mut_time = time.time() - start_time
        log_lines.append(f"随机变异执行时间: {ran_mut_time:.2f} 秒")


    # 添加交互次数和分布记录
    log_lines.append(f"生成阶段总交互次数：{gen_total_interaction_times}")
    log_lines.append(f"变异阶段总交互次数：{mut_total_interaction_times}")
    log_lines.append(f"随机变异阶段总交互次数：{ran_total_interaction_times}")
    log_lines.append(f"生成阶段交互次数分布：{str(gen_times_list)}")
    log_lines.append(f"变异阶段交互次数分布：{str(mut_times_list)}")
    log_lines.append(f"随机变异阶段交互次数分布：{str(ran_times_list)}")

    # 打印日志
    for line in log_lines:
        print(line)

    # 写入日志到文件
    with open(output_file, "a") as f:
        f.write("\n".join(log_lines) + "\n")
        