# Nüwa

Nüwa, the first LLM-based approach for MLIR fuzzing. 

## License  
This project is licensed under the Apache License 2.0.  
See [LICENSE.md](LICENSE.md) for details.  
 
## Get started

``` bash
git clone https://github.com/anonymity88/nvwa.git
cd nvwa
# Set up the llvm-project
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout bec839d8eed9dd13fa7eaffd50b28f8f913de2e2
rm -r build
mkdir build
cd build
cmake -G Ninja ../llvm \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_C_COMPILER=/root/clang+llvm-17.0.4-x86_64-linux-gnu-ubuntu-22.04/bin/clang \
    -DCMAKE_CXX_COMPILER=/root/clang+llvm-17.0.4-x86_64-linux-gnu-ubuntu-22.04/bin/clang++\
    -DCMAKE_C_FLAGS="-g -O0 -fprofile-arcs -ftest-coverage" \
    -DCMAKE_CXX_FLAGS="-g -O0 -fprofile-arcs -ftest-coverage" \
    -DCMAKE_EXE_LINKER_FLAGS="-g -fprofile-arcs -ftest-coverage -lgcov" \
    -DLLVM_PARALLEL_LINK_JOBS=2

ninja -j 40
```

## Use Nüwa

With `Nüwa`, you can easily Generate test cases from the operator specifications in the 'specifications' directory with a single command:
```bash
python generate/main.py --opt MLIRGensyn --seeds 100 --date test
```

Perform fuzz testing using the generated test cases.
```bash
python fuzz/fuzz.py
```

结果处理，自动去重crash：
```bash
python fuzz/coverage/BugReport.py
```

## code structure
```tree
nvwa/
├── README.md               # 项目总览文档
├── LICENSE                 # Apache 2.0协议文本
├── fuzz                    # 模糊测试模块
│   ├── coverage            # 模糊测试分析工具，包括覆盖率、检测crash去重等
│   ├── draw                # 结果统计图表分析工具
│   └── fuzz.py             # 模糊测试主程序
├── generate                # 用例生成模块
│   ├── generate_utils.py   # 生成器与变异器基础工具文件
│   ├── generate.py         # 生成器文件
│   ├── mutate.py           # 变异器文件
│   └── mian.py             # 用例生成主程序
├── llvm-project     
├── prompt                  # 生成与变异各阶段所用到的prompt框架
├── prompt                  # 预处理和试验阶段的工具脚本
└── specifications          # MLIR各方言的算子规范（已按方言算子分类）
```
