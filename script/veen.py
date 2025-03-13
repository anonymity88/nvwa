import json
import matplotlib.pyplot as plt
from matplotlib_venn import venn3

def load_json(file_path):
    """加载并解析 JSON 文件"""
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data['dialects']

def extract_operations(dialects):
    """提取所有的操作"""
    all_operations = set()
    for operations in dialects.values():
        all_operations.update(operations)
    return all_operations

def plot_venn(operations1, operations2, operations3, labels, output_pdf):
    """绘制三个集合的韦恩图并保存为PDF"""
    venn_data = {
        '100': len(operations1 - operations2 - operations3),
        '010': len(operations2 - operations1 - operations3),
        '001': len(operations3 - operations1 - operations2),
        '110': len(operations1 & operations2 - operations3),
        '101': len(operations1 & operations3 - operations2),
        '011': len(operations2 & operations3 - operations1),
        '111': len(operations1 & operations2 & operations3)
    }

    plt.figure(figsize=(8, 8))
    venn = venn3(subsets=venn_data, set_labels=labels)

    # 保持圆的大小一致
    for i in venn.patches:
        i.set_edgecolor('black')  # 设置边缘颜色
        i.set_alpha(0.3)  # 设置透明度，减少颜色的混合

    # 设置数字大小，不设置圆的大小
    for i, label in enumerate(venn.subset_labels):
        label.set_fontsize(20)
        label.set_fontweight('bold')

    # 设置圆圈的大小固定
    for i in venn.patches:
        i.set_area(1000)  # 设置圆的固定大小（大小比例）

    # 设置标题
    plt.title('Intersection of JSON Files', fontsize=20, fontweight='bold')

    # 保存为PDF
    plt.savefig(output_pdf, format='pdf')
    plt.close()

if __name__ == "__main__":
    # 输入文件路径
    file_paths = [
        '/home/llm/seeds/seeds-MLIRgensyn-500/summary_result.json',  # 替换为第一个文件路径
        '/home/llm/seeds/MLIRod_summary_result.json',  # 替换为第二个文件路径
        '/home/llm/seeds/MLIRSmith_summary_result.json'   # 替换为第三个文件路径
    ]

    # 输出 PDF 文件路径
    output_pdf = 'operations_intersection_venn_diagram.pdf'

    # 加载并提取操作
    operations = []
    for file_path in file_paths:
        dialects = load_json(file_path)
        operations.append(extract_operations(dialects))

    # 绘制韦恩图并保存为PDF
    labels = ['File 1', 'File 2', 'File 3']
    plot_venn(operations[0], operations[1], operations[2], labels, output_pdf)

    print(f"Venn diagram saved to {output_pdf}")
