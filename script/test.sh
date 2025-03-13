#!/bin/bash

# 源目录
src_dir="/home/llm/official_IRs/Dialect/mlir"
# 目标目录
dst_base_dir="/home/llm/official_IRs/Dialect"

# 遍历源目录中的所有子目录
for subdir in "$src_dir"/*/; do
    # 获取子目录名称
    subdir_name=$(basename "$subdir")
    # 目标目录
    dst_dir="$dst_base_dir/$subdir_name"

    # 创建目标目录（如果不存在）
    mkdir -p "$dst_dir"

    # 遍历子目录中的所有 .mlir 文件
    for file in "$subdir"/*.mlir; do
        if [ -f "$file" ]; then
            # 获取文件名
            filename=$(basename "$file")
            # 目标文件路径
            dst_file="$dst_dir/$filename"

            # 如果目标文件已存在，重命名文件
            if [ -e "$dst_file" ]; then
                # 获取文件名和扩展名
                base_name="${filename%.*}"
                ext="${filename##*.}"
                # 计数器，用于重命名文件
                count=1
                while [ -e "$dst_dir/$base_name"_"$count.$ext" ]; do
                    ((count++))
                done
                # 移动并重命名文件
                mv "$file" "$dst_dir/$base_name"_"$count.$ext"
            else
                # 直接移动文件
                mv "$file" "$dst_file"
            fi
        fi
    done
done
