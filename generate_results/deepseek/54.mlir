module {
  func.func @main(
      %arg0: index, %arg1: index,
      %argA: tensor<?x?xf32>, %argB: tensor<?x?xf32>,
      %source: tensor<4x4xf32>, %dest: tensor<4x4xf32>,
      %dest_memref: memref<4x4xf32>,
      %memref_to_clone: memref<?xf32>
  ) -> (tensor<?x?xf32>, tensor<4x4xf32>, memref<?xf32>) {
    // 1. Allocate tensor for matmul operation
    %tensor_alloc = bufferization.alloc_tensor(%arg0, %arg1) : tensor<?x?xf32>
    
    // 2. Perform matrix multiplication
    %result_matmul = linalg.matmul
      ins(%argA, %argB: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%tensor_alloc: tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // 3. Materialize tensor in destination tensor
    %result_materialized = bufferization.materialize_in_destination %source in %dest
      : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>
    
    // 4. Materialize tensor in writable memref
    bufferization.materialize_in_destination %source in restrict writable %dest_memref
      : (tensor<4x4xf32>, memref<4x4xf32>) -> ()
    
    // 5. Clone memref
    %cloned_memref = bufferization.clone %memref_to_clone : memref<?xf32> to memref<?xf32>
    
    return %result_matmul, %result_materialized, %cloned_memref : tensor<?x?xf32>, tensor<4x4xf32>, memref<?xf32>
  }
}