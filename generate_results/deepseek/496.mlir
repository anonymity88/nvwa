#DenseMatrix = #sparse_tensor.encoding<{map = (d0, d1) -> (d0 : dense, d1 : dense)}>
#ID_MAP = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main(%arg0: tensor<16x32xf64, #DenseMatrix>, %arg1: index, %arg2: memref<100xindex>, %arg3: memref<?xf32>, %arg4: memref<10xi32>) -> (tensor<16x32xf64, #DenseMatrix>, memref<100xindex>, memref<?xf32>, memref<10xi32>) {
    %0 = call @sparse_load_ins(%arg0) : (tensor<16x32xf64, #DenseMatrix>) -> tensor<16x32xf64, #DenseMatrix>
    %1:3 = call @sparse_sort_coo_quick(%arg1, %arg2, %arg3, %arg4) : (index, memref<100xindex>, memref<?xf32>, memref<10xi32>) -> (memref<100xindex>, memref<?xf32>, memref<10xi32>)
    return %0, %1#0, %1#1, %1#2 : tensor<16x32xf64, #DenseMatrix>, memref<100xindex>, memref<?xf32>, memref<10xi32>
  }

  func.func @sparse_load_ins(%arg0: tensor<16x32xf64, #DenseMatrix>) -> tensor<16x32xf64, #DenseMatrix> {
    %0 = sparse_tensor.load %arg0 hasInserts : tensor<16x32xf64, #DenseMatrix>
    return %0 : tensor<16x32xf64, #DenseMatrix>
  }

  func.func @sparse_sort_coo_quick(%arg0: index, %arg1: memref<100xindex>, %arg2: memref<?xf32>, %arg3: memref<10xi32>) -> (memref<100xindex>, memref<?xf32>, memref<10xi32>) {
    sparse_tensor.sort quick_sort %arg0, %arg1 jointly %arg2, %arg3 {perm_map = #ID_MAP, ny = 1: index} : memref<100xindex> jointly memref<?xf32>, memref<10xi32>
    return %arg1, %arg2, %arg3 : memref<100xindex>, memref<?xf32>, memref<10xi32>
  }
}