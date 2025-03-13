import json

# 读取原始 JSON 文件
with open('/home/llm/data/finetuningtest_0921.jsonl', 'r') as file:
    # 逐行读取文件内容，并对每行的 JSON 字符串进行处理
    formatted_data = []
    for line in file:
        # 解析 JSON 字符串
        json_obj = json.loads(line)
        # 对内容进行处理
        json_obj['prompt'] = json_obj['prompt'].strip()
        # 将 passes 字段改名为 completion
        json_obj['completion'] = json_obj.pop('completion').strip()
        # 将处理后的 JSON 对象添加到列表中
        formatted_data.append(json_obj)

# 将处理后的内容写回新的 JSON 文件中
with open('/home/llm/data/finetuningtest_0921.json', 'w') as file:
    # 写入 JSON 数组的起始括号
    file.write('[\n')
    # 逐行写入处理后的 JSON 字符串，并在每个对象之间添加逗号
    for i, obj in enumerate(formatted_data):
        if i != 0:
            file.write(',\n')  # 添加逗号，除了第一个对象外都在前面添加逗号
        file.write('\t' + json.dumps(obj, indent=2).replace('\n', '\n\t'))
    # 写入 JSON 数组的结束括号
    file.write('\n]')
