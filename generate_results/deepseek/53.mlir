#layout = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main(%d1: index, %d2: index, %a: tensor<?x?xf32>, %b: tensor<?x?xf32>, %source: tensor<4x4xf32>, %dest: tensor<4x4xf32>, %dest_memref: memref<4x4xf32>, %arg: tensor<4x?xf32>, %noe: index) -> (tensor<?x?xf32>, tensor<4x4xf32>, memref<4x?xf32, #layout, 0>) {
    // Allocate tensor for matmul without size hint
    %c = bufferization.alloc_tensor(%d1, %d2) : tensor<?x?xf32>
    
    // Perform matrix multiplication
    %result_matmul = linalg.matmul
      ins(%a, %b: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%c: tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Allocate tensor for matmul with size hint
    %c_hint = bufferization.alloc_tensor(%d1, %d2) size_hint = %noe : tensor<?x?xf32>
    
    // Perform matrix multiplication with size hint
    %result_matmul_hint = linalg.matmul
      ins(%a, %b: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%c_hint: tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Materialize tensor in destination tensor
    %result_materialized = bufferization.materialize_in_destination %source in %dest
      : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>
    
    // Materialize tensor in writable memref
    bufferization.materialize_in_destination %source in restrict writable %dest_memref
      : (tensor<4x4xf32>, memref<4x4xf32>) -> ()
    
    // Convert tensor to memref
    %m = bufferization.to_memref %arg : memref<4x?xf32, #layout, 0>
    
    return %result_matmul, %result_materialized, %m : tensor<?x?xf32>, tensor<4x4xf32>, memref<4x?xf32, #layout, 0>
  }
}