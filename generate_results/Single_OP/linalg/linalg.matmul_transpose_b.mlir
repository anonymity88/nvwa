func.func @matmul_transpose_b(%arg0: memref<3x5xf32>, %arg1: memref<7x5xf32>, %arg2: memref<3x7xf32>) {
  linalg.matmul_transpose_b ins(%arg0, %arg1 : memref<3x5xf32>, memref<7x5xf32>) outs(%arg2: memref<3x7xf32>)
  return
}