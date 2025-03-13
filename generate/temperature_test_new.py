import GPT_genetrate
import time

dialects = ["tosa", "affine", "linalg", "spirv"]

for dialect in dialects:
    output_file = f"/home/llm/test/temperature_new_{dialect}.txt"

    # 创建 Generator 实例
    generator = GPT_genetrate.Generator(dialect=dialect, OPscount=3)
    
    print(f"开始处理方言：{dialect}")

    # 初始化记录结构
    temperature_values = [round(x * 0.1, 1) for x in range(15, -1, -1)]  # 从 1.5 到 0.0
    results = {temp: {"success": 0, "failure": 0, "total_interactions": 0, "time": 0.0} for temp in temperature_values}

    # 外层循环 50 次
    for outer_loop in range(50):
        start_time_outer = time.time()
        print(f"外层循环 {outer_loop + 1} 开始")

        # 遍历 temperature 值
        for i, temp in enumerate(temperature_values):
            single_start_time = time.time()

            # 第一个 temperature 使用 generate_multi，其余使用 generate_multi_temperature
            if i == 0:
                mlir, interaction_times = generator.generate_multi(temperature=temp)
            else:
                mlir, interaction_times = generator.generate_multi_temperature(temperature=temp)

            # 更新统计信息
            results[temp]["total_interactions"] += interaction_times
            if mlir:
                results[temp]["success"] += 1
            else:
                results[temp]["failure"] += 1

            # 更新时间
            single_end_time = time.time()
            results[temp]["time"] += single_end_time - single_start_time

        # 每次外层循环写入一次文件，防止数据丢失
        with open(output_file, "w") as f:
            f.write(f"外层循环 {outer_loop + 1} 结果：\n")
            for temp in temperature_values:
                f.write(f"temperature = {temp}:\n")
                f.write(f"  成功次数：{results[temp]['success']}\n")
                f.write(f"  失败次数：{results[temp]['failure']}\n")
                f.write(f"  总交互次数：{results[temp]['total_interactions']}\n")
                f.write(f"  累计时长：{results[temp]['time']:.2f} 秒\n")
            f.write("\n")  # 空行分隔不同循环的结果

        end_time_outer = time.time()
        print(f"外层循环 {outer_loop + 1} 完成，用时 {end_time_outer - start_time_outer:.2f} 秒")

    print(f"测试完成，结果已保存到 {output_file}")
