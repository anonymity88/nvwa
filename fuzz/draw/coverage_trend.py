import re
import matplotlib.pyplot as plt
from datetime import datetime
from matplotlib.font_manager import FontProperties
import numpy as np

# 解析日志文件
def parse_log_file(file_path):
    timestamps = []
    covered_lines = []
    taken_branches = []

    with open(file_path, 'r') as file:
        for line in file:
            # 匹配时间戳
            timestamp_match = re.match(r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+)', line)
            if timestamp_match:
                timestamp = datetime.strptime(timestamp_match.group(1), '%Y-%m-%d %H:%M:%S.%f')
                timestamps.append(timestamp)

            # 匹配 Covered Lines 和 Taken Branches
            covered_lines_match = re.search(r'Covered Lines: (\d+)', line)
            taken_branches_match = re.search(r'Taken Branches: (\d+)', line)
            if covered_lines_match:
                covered_lines.append(int(covered_lines_match.group(1)))
            if taken_branches_match:
                taken_branches.append(int(taken_branches_match.group(1)))

    return timestamps, covered_lines, taken_branches

# 绘制图表并保存为PNG文件
def plot_line_coverage(plt,timestamps, covered_lines, taken_branches,label):
    
    # 计算时间偏移
    start_time = timestamps[0]
    time_deltas = [(ts - start_time).total_seconds() / 3600 for ts in timestamps]  # 转换为小时

    plt.plot(time_deltas, covered_lines, label=label, linewidth=2)
    # plt.plot(time_deltas, taken_branches, label='Taken Branches', marker='x')
    return plt


def plot_branch_coverage(plt, timestamps, covered_lines, taken_branches,label):
    # 计算时间偏移
    start_time = timestamps[0]
    time_deltas = [(ts - start_time).total_seconds() / 3600 for ts in timestamps]  # 转换为小时

    # plt.plot(time_deltas, covered_lines, label='Covered Lines', marker='o')
    plt.plot(time_deltas, taken_branches, label=label, linewidth=2)
    return plt

# 对MLIRod实验得到的行覆盖率和分支覆盖率信息进行统计并绘制图表
if __name__ == "__main__":
    plt.figure(figsize=(7, 4))

    log_file_path = '/home/workdir/tracer/fuzz_tool/data/ablation/coverage_0805rt_cov.log'  # 日志文件路径
    timestamps, covered_lines, taken_branches = parse_log_file(log_file_path)
    plt = plot_branch_coverage(plt,timestamps, covered_lines, taken_branches, "TRACER-R")

    log_file_path = '/home/workdir/tracer/fuzz_tool/data/ablation/coverage_0805rrt_cov.log'  # 日志文件路径
    timestamps, covered_lines, taken_branches = parse_log_file(log_file_path)
    plt = plot_branch_coverage(plt,timestamps, covered_lines, taken_branches, "TRACER-T")

    log_file_path = '/home/workdir/tracer/fuzz_tool/data/ablation/coverage_0805D_cov.log'  # 日志文件路径
    timestamps, covered_lines, taken_branches = parse_log_file(log_file_path)
    plt = plot_branch_coverage(plt,timestamps, covered_lines, taken_branches, "TRACER-D")

    log_file_path = '/home/workdir/tracer/fuzz_tool/data/ablation/coverage_0805P_cov.log'  # 日志文件路径
    timestamps, covered_lines, taken_branches = parse_log_file(log_file_path)
    plt = plot_branch_coverage(plt,timestamps, covered_lines, taken_branches, "TRACER")




    plt.xlabel('Time(hour)', fontsize=14)
    plt.ylabel('Branch Coverage',fontsize=14)
    # plt.title('Coverage Over Time')
    plt.legend()
    plt.grid(True)

    plt.xticks(ticks=[0, 4, 8, 12, 16, 20, 24], labels=['0', '4', '8', '12', '16', '20', '24'])
    plt.tight_layout()

    font = FontProperties(size=9,weight='normal')
    plt.legend(loc='lower right', frameon=True,prop=font)
    # # plt.lim(0, 350)
    # # xticks = np.linspace(0,12,7)
    # # yticks = np.linspace(0,350,8)
    # plt.yticks(yticks,fontsize=14)
    # plt.xticks(xticks,fontsize=14)

    ax = plt.gca()
    plt.grid(True)
    ax.xaxis.grid(True, linestyle='dotted')
    ax.yaxis.grid(True, linestyle='dotted')

    output_file_path = './coverage_over_time.png'  # 保存图表的文件路径
    plt.savefig(output_file_path)
    plt.savefig('./coverage_over_time.pdf')
    plt.close()






