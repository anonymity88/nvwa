import pymysql
import json

output = "/home/llm/data/MFapi1_IRs.json"

with open(output, "w") as json_file:
    json_file.write('')  # 创建文件

# 连接数据库
conn = pymysql.connect(
    host="10.15.1.202",
    port=23112,
    user="root",
    password="root123",
    database="mlir"
)

# 创建游标对象
cursor = conn.cursor()

# 查询数据库
query = "SELECT * FROM seed_pool_MFapi1 WHERE preid = 0"
cursor.execute(query)

# 提取数据并格式化为JSON格式
formatted_rows = []
for row in cursor.fetchall():
    IRs = row[6]
    formatted_row = {
        "IRs": IRs
    }
    formatted_rows.append(formatted_row)

# 关闭数据库连接
cursor.close()
conn.close()

# 将数据写入JSON文件
with open(output, "a") as json_file:
    json_file.write('[\n')  # 写入 JSON 数组的起始括号
    for i, formatted_row in enumerate(formatted_rows):
        if i != 0:
            json_file.write(',\n')  # 添加逗号，除了第一个对象外都在前面添加逗号
        json_file.write('\t' + json.dumps(formatted_row, indent=2).replace('\n', '\n\t'))  # 写入格式化后的 JSON 对象，并添加制表符
    json_file.write('\n]')  # 写入 JSON 数组的结束括号
