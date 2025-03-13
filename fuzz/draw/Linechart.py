import matplotlib.pyplot as plt
import numpy as np

# 示例数据，你可以用自己的数据替换
version = ['16.0.1', '17.0.6', '18.1.0-rc1', '19.1.0-rc1', '20.0.0git']  # 版本号
dialects = [38, 43, 44, 46, 48]  # 方言数据
operations = [963, 1113, 1415, 1444, 1586]  # 算子数据

# 设置图形和大小
fig, ax1 = plt.subplots(figsize=(11, 5))

# 绘制柱状图，改为浅蓝色，蓝色框
bar_width = 0.6
x = np.arange(len(version))
ax1.bar(x, dialects, color='skyblue', width=bar_width, edgecolor='dodgerblue', label='Dialect', zorder=3)  # 蓝色框

# 设置柱状图纵坐标范围，使其从36到50，步长小一点
ax1.set_ylim(36, 50)  # 设置范围为36到50
ax1.set_yticks(np.arange(36, 52, 3))  # 设置纵坐标刻度步长为2

ax1.set_xlabel('LLVM Version', fontsize=25)
ax1.set_ylabel('# Dialects', fontsize=25, color='black')  # 修改为黑色
ax1.tick_params(axis='y', labelcolor='black', labelsize=21)   # 修改为黑色

# 添加第二个纵坐标
ax2 = ax1.twinx()
ax2.plot(x, operations, color='brown', marker='o', markersize=8, linestyle='-', linewidth=2, label='Operation', zorder=2)  # 修改为棕色

# 设置右侧纵坐标范围从900到1600，步长为100
ax2.set_ylim(900, 1600)  # 设置范围
ax2.set_yticks(np.arange(900, 1700, 150))  # 设置纵坐标刻度步长为100

ax2.set_ylabel('# Operations', fontsize=25, color='black')  # 修改为黑色
ax2.tick_params(axis='y', labelcolor='black', labelsize=21)     # 修改为黑色

# 设置 x 轴刻度
ax1.set_xticks(x)
ax1.set_xticklabels(version, fontsize=20)  # 修改横轴数字大小为20

# 将两个图例放到同一个框里
handles, labels = ax1.get_legend_handles_labels()  # 获取第一个图例的句柄和标签
handles2, labels2 = ax2.get_legend_handles_labels()  # 获取第二个图例的句柄和标签
handles.extend(handles2)  # 合并两个图例的句柄
labels.extend(labels2)  # 合并两个图例的标签
plt.legend(handles, labels, loc='upper left', bbox_to_anchor=(0, 1), frameon=True, fontsize=22)  # 绘制合并的图例

# 显示横向虚线网格，精确控制虚线的点与点之间的间隔
ax1.grid(True, which='major', axis='y', linestyle='-', color='gray', linewidth=0.5, zorder=1)
ax1.tick_params(axis='y', labelcolor='black', labelsize=21)

# 控制虚线的点与点之间的间隔
ax1.grid(True, which='major', axis='y', linestyle=':', color='gray', linewidth=0.5, zorder=1, dashes=[6, 10])  # [6, 3]表示6个点线段，3个间隔


# 显示图形
plt.tight_layout()
plt.savefig('linechart.pdf')
plt.close()
