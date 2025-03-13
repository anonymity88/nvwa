import os
import pymysql

# 数据库连接信息
db_config = {
    'host': '10.15.1.202',
    'port': 23112,
    'user': 'root',
    'password': 'root123',
    'database': 'cbc'
}

# 目标文件夹
output_dir = 'generate_results/mutate_IRs/0930'

# 确保文件夹存在，不存在则创建
os.makedirs(output_dir, exist_ok=True)

# 连接数据库
connection = pymysql.connect(
    host=db_config['host'],
    port=db_config['port'],
    user=db_config['user'],
    password=db_config['password'],
    database=db_config['database']
)

try:
    with connection.cursor() as cursor:
        # 查询 source 为 "M" 的所有 content
        sql = "SELECT content FROM seed_pool_0927 WHERE source = %s"
        cursor.execute(sql, ('M',))
        results = cursor.fetchall()

        # 保存每个 content 为 .mlir 文件
        for idx, row in enumerate(results, start=1):
            content = row[0]  # 获取 content 列的值

            # 跳过内容为 "module {\n}" 的情况
            if content.strip() == "module {\n}":
                print(f"Skipped empty module at index {idx}")
                continue

            # 文件命名
            file_name = f"{idx}.mlir"
            file_path = os.path.join(output_dir, file_name)

            # 写入 .mlir 文件
            with open(file_path, 'w') as f:
                f.write(content)

            print(f"Saved {file_name}")

finally:
    # 关闭数据库连接
    connection.close()

print("All valid .mlir files have been saved.")
