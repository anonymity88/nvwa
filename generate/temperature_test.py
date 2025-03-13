import GPT_genetrate
import time

output_file = "/home/llm/test/temperature_test_spirv.txt"

# 创建 Generator 实例
generator = GPT_genetrate.Generator(dialect="spirv", OPscount = 3)

for temp in [round(x * 0.1, 1) for x in range(16)]:  # 0.0 到 1.5，步长为 0.1
    total_interaction_times = 0
    success_count = 0
    failure_count = 0

    # 记录开始时间
    start_time = time.time()

    # 调用函数 50 次
    for _ in range(50):
        mlir, interaction_times = generator.generate_multi(temperature = temp)  # 调用函数
        total_interaction_times += interaction_times

        if mlir:  # 判断 mlir 是否为空
            success_count += 1
        else:
            failure_count += 1

    # 记录结束时间和总时长
    end_time = time.time()
    duration = end_time - start_time

    # 打开文件并写入结果
    with open(output_file, "a") as f:
        f.write(f"temperature = {temp}：\n")
        f.write(f"总交互次数：{total_interaction_times}\n")
        f.write(f"生成成功次数：{success_count}\n")
        f.write(f"生成失败次数：{failure_count}\n")
        f.write(f"时长：{duration:.2f} 秒\n")
        f.write("\n")  # 空行分隔不同 temperature 的结果

print(f"测试完成，结果已保存到 {output_file}")