import os
import re
from datetime import datetime
import matplotlib.pyplot as plt
from collections import defaultdict

def bug_count_multi(folder_info, fig_path):
    # 初始化bug计数器和时间存储
    cumulative_bug_data = {}

    # 标记样式的列表
    markers = ['o', 'x', '^', 'D', '*', 'p', 'H', 'X']
    marker_idx = 0

    # 遍历多个目录路径
    for folder_path, folder_name in folder_info.items():
        print(f"Processing directory: {folder_path} ({folder_name})")
        bug_times = defaultdict(int)
        skipped_files = 0
        processed_files = 0

        for root, dirs, files in os.walk(folder_path):
            for file in files:
                if file.endswith('.log') or file.endswith('.txt'):
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()

                        # 提取第一行时间信息
                        first_line = content.splitlines()[0]
                        timestamp = None

                        # 匹配时间戳的格式
                        if re.match(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', first_line):
                            timestamp = datetime.strptime(first_line, '%Y-%m-%d %H:%M:%S')
                        elif re.match(r'\d{14}', first_line):
                            timestamp = datetime.strptime(first_line, '%Y%m%d%H%M%S')
                        elif re.match(r'Current Time: \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', first_line):
                            timestamp_str = first_line.split('Current Time: ')[-1]
                            timestamp = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S')

                        if not timestamp:
                            print(f"Skipped file due to invalid timestamp: {file_path}")
                            skipped_files += 1
                            continue

                        # 检查内容是否包含关键字
                        if 'submit a bug' not in content and 'time out' in content:
                            print(f"Skipped file due to content mismatch: {file_path}")
                            skipped_files += 1
                            continue

                        # 累计BUG时间
                        bug_times[timestamp] += 1
                        processed_files += 1
                    except Exception as e:
                        print(f"Error processing file {file_path}: {e}")
                        skipped_files += 1

        print(f"Directory {folder_name} ({folder_path}): Processed {processed_files} files, Skipped {skipped_files} files.")

        # 记录该目录的时间点和BUG计数
        sorted_times = sorted(bug_times.keys())
        cumulative_count = 0
        cumulative_bugs = []
        for time in sorted_times:
            cumulative_count += bug_times[time]
            cumulative_bugs.append((time, cumulative_count))
        
        cumulative_bug_data[folder_name] = cumulative_bugs

    # 绘制所有目录的累计BUG曲线
    plt.figure(figsize=(6, 4))  # 单栏宽度，适合论文排版
    for folder_name, data in cumulative_bug_data.items():
        if not data:
            print(f"No valid data for directory: {folder_name}")
            continue
        times, counts = zip(*data)
        relative_times = [(time - times[0]).total_seconds() / 3600 for time in times]
        
        # 设置不同的标记样式和颜色
        plt.plot(relative_times, counts, marker=markers[marker_idx % len(markers)], linestyle='-', 
                 label=f"{folder_name}", markersize=5, linewidth=1)
        marker_idx += 1

    # 图表配置
    plt.xlabel('Time (hour)', fontsize=20)
    plt.ylabel('# Bugs', fontsize=20)
    plt.xticks(range(0, 25, 4), fontsize=16)  # 横坐标从0显示到24，步长4
    plt.yticks(range(0, 51, 10), fontsize=16)  # 纵坐标从0显示到50，步长10
    plt.tick_params(axis='both', labelsize=16)

    plt.grid(True)
    plt.tight_layout()

    plt.savefig(f'{fig_path}_BUG.pdf')
    plt.close()
    print(f"Bug trend graph saved at {fig_path}_BUG.pdf")
    # plt.show()


if __name__ == "__main__":
    # 输入多个目录路径及其名称
    folder_info = {
        '/home/llvm-project1/data/crash_deduplicate/': 'Nüwa',
        '/home/llvm-project1/data/crash_deduplicate-MLIRGen': 'Nüwa-Gen',
        '/home/llvm-project1/data/crash_deduplicate_MLIRsyn': 'Nüwa-Mut',
        '/home/llvm-project1/data/crash_deduplicate-MLIRSmith':'MLIRSmith',
        '/home/llvm-project1/data/bug_report-MLIRod_duplicate':'MLIRod',
    }
    fig_path = './cumulative_bug_trend_multi'

    bug_count_multi(folder_info, fig_path)
