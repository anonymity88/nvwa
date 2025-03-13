import IR_analysis
import random
import os

# # List all entries in the base folder
# for entry in os.listdir("/home/llm/generate_results/mutate_IRs"):
#     subfolder_path = os.path.join("/home/llm/generate_results/mutate_IRs", entry)
    
#     # Process only directories
#     if os.path.isdir(subfolder_path):
#         print(f"Processing folder: {subfolder_path}")
#         selected_files = IR_analysis.select_by_complexity(subfolder_path)
    
# selected_files = IR_analysis.select_by_complexity("/home/llm/generate_results/Single_OP/acc")

x = [4, 4, 1, 4, 4, 4, 4, 4, 4, 2, 4, 4, 4, 4, 4, 4, 3, 1, 2, 4, 4, 4, 4, 4, 1, 4, 4, 4, 1, 4, 4, 4, 4, 1, 2, 2, 4, 4, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 2, 4, 4, 4, 4, 4, 2, 2, 1, 1]
# 计算和
total = sum(x)

# 计算平均数
average = total / len(x) if x else 0  # 防止列表为空导致除零错误

print(f"列表的和为: {total}")
print(f"列表的平均数为: {average:.2f}")
print(pow(2*9,1)/5822)