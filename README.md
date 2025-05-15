# Nüwa

Nüwa, the first LLM-based approach for MLIR fuzzing. 
 
## Get started

``` bash
git clone https://github.com/anonymity88/nvwa.git
cd nvwa
# Set up the llvm-project
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
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

## Use MLIRSmith

With `Nüwa`, you can easily Generate test cases from the operator specifications in the 'specifications' directory with a single command:
```bash
python generate/main.py --opt MLIRGensyn --seeds 100 --date test
```

Perform fuzz testing using the generated test cases.
```bash
python /home/Nvwa/fuzz/fuzz.py
```

