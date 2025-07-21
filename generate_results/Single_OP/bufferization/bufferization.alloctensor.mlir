module {
  func.func @main(%arg0: index, %arg1: index, %argA: tensor<?x?xf32>, %argB: tensor<?x?xf32>) -> tensor<?x?xf32> {
    // Allocate a tensor with dynamic dimensions using bufferization.alloctensor
    %tensor_alloc = bufferization.alloc_tensor(%arg0, %arg1) : tensor<?x?xf32>

    // Use the allocated tensor as the output for a matmul operation
    %result = linalg.matmul
      ins(%argA, %argB: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%tensor_alloc: tensor<?x?xf32>) -> tensor<?x?xf32>

    return %result : tensor<?x?xf32>
  }
}