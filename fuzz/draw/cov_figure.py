import os
import re
import matplotlib.pyplot as plt

# 解析日志文件
def parse_log_file(file_path):
    times = []
    covered_lines = []
    taken_branches = []

    with open(file_path, 'r') as file:
        for line in file:
            # 匹配 Times: 后面的数字
            times_match = re.search(r'Times:(\d+)', line)
            if times_match:
                time_value = int(times_match.group(1))
                times.append(time_value)

            # 匹配 Covered Lines 和 Taken Branches
            covered_lines_match = re.search(r'Covered Lines: (\d+)', line)
            taken_branches_match = re.search(r'Taken Branches: (\d+)', line)
            if covered_lines_match:
                covered_lines.append(int(covered_lines_match.group(1)))
            if taken_branches_match:
                taken_branches.append(int(taken_branches_match.group(1)))

    return times, covered_lines, taken_branches

# 绘制单独的图
def plot_individual_coverage(file_data, output_file_prefix):
    # 标记样式的列表
    markers = ['o', 'x', '^', 'D', '*', 'p', 'H', 'X']
    marker_idx = 0

    def highlight_points(ax, x, y, interval, size, marker):
        for i in range(len(x)):
            if i > 1 and i % interval == 0:
                ax.scatter(x[i], y[i], color=ax.lines[-1].get_color(), 
                           s=size, marker=marker, zorder=2)

    # 绘制 Covered Lines
    plt.figure(figsize=(6, 4))  # 单栏宽度，适合论文排版
    ax = plt.gca()
    for data, label in file_data:
        times, covered_lines, _ = data
        # 计算小时数，确保范围是从0到24
        hours = [min(24, t / 2) for t in times]  # 转换为小时并确保不超过24小时
        plt.plot(hours, covered_lines, marker=markers[marker_idx % len(markers)], 
                 label=label, markersize=2, linewidth=1)
        highlight_points(ax, hours, covered_lines, 7, 40, markers[marker_idx % len(markers)])  # 每隔 7 个点放大
        marker_idx += 1

    # 设置 x 轴的刻度为 0, 4, 8, 12, 16, 20, 24
    plt.xticks(range(0, 25, 4), fontsize=16)

    plt.xlabel('Time (hour)', fontsize=20)
    plt.ylabel('Line Coverage', fontsize=20)
    plt.tick_params(axis='both', labelsize=16)
    plt.legend(loc='lower right', fontsize=15, ncol=2)  # 图例分两列
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(f'{output_file_prefix}_covered_lines.pdf')
    plt.close()

    marker_idx = 0
    # 绘制 Taken Branches
    plt.figure(figsize=(6, 4))  # 单栏宽度
    ax = plt.gca()
    for data, label in file_data:
        times, _, taken_branches = data
        # 计算小时数，确保范围是从0到24
        hours = [min(24, t / 2) for t in times]  # 转换为小时并确保不超过24小时
        plt.plot(hours, taken_branches, marker=markers[marker_idx % len(markers)], 
                 label=label, markersize=2, linewidth=1)
        highlight_points(ax, hours, taken_branches, 7, 40, markers[marker_idx % len(markers)])  # 每隔 7 个点放大
        marker_idx += 1

    # 设置 x 轴的刻度为 0, 4, 8, 12, 16, 20, 24
    plt.xticks(range(0, 25, 4), fontsize=16)

    plt.xlabel('Time (hour)', fontsize=20)
    plt.ylabel('Branch Coverage', fontsize=20)
    plt.tick_params(axis='both', labelsize=16)
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(f'{output_file_prefix}_taken_branches.pdf')
    plt.close()

# 主程序
if __name__ == "__main__":
    log_file_to_label = {
        "/home/llvm-project/data/1014/coverage_MLIRgensyn_1014.log": 'Nüwa',
        "/home/llvm-project/data/1211/coverage_MLIRgensyn_1211.log": 'Nüwa-Gen',
        "/home/llvm-project1/data/1211/coverage_MLIRgensyn_1211.log": 'Nüwa-Mut',
        "/home/llvm-project/data/0806/coverage_Smith_0806.log": 'MLIRSmith',
        "/home/llvm-project/data/0806/coverage_MLIROd.log": 'MLIRod',
    }

    file_data = []
    for file_path, label in log_file_to_label.items():
        if os.path.exists(file_path):
            times, covered_lines, taken_branches = parse_log_file(file_path)
            file_data.append(((times, covered_lines, taken_branches), label))
        else:
            print(f"Warning: The file {file_path} does not exist.")

    output_file_prefix = './coverage_comparison'
    plot_individual_coverage(file_data, output_file_prefix)

    print(f"Coverage charts have been saved as:")
    print(f"{output_file_prefix}_covered_lines.pdf")
    print(f"{output_file_prefix}_taken_branches.pdf")
