module {
  func.func @main(
      %arg0: index, %arg1: index,
      %argA: tensor<?x?xf32>, %argB: tensor<?x?xf32>,
      %source: tensor<4x4xf32>, %dest: tensor<4x4xf32>,
      %dest_memref: memref<4x4xf32>,
      %memref_to_clone: memref<?xf32>
  ) -> (tensor<?x?xf32>, tensor<4x4xf32>, memref<?xf32>) {
    %tensor_alloc = bufferization.alloc_tensor(%arg0, %arg1) : tensor<?x?xf32>
    
    %result_matmul = linalg.matmul
      ins(%argA, %argB: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%tensor_alloc: tensor<?x?xf32>) -> tensor<?x?xf32>
    
    %result_materialized = bufferization.materialize_in_destination %source in %dest
      : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>
    
    bufferization.materialize_in_destination %source in restrict writable %dest_memref
      : (tensor<4x4xf32>, memref<4x4xf32>) -> ()
    
    %cloned_memref = bufferization.clone %memref_to_clone : memref<?xf32> to memref<?xf32>
    
    // Call the auto_dealloc function
    call @auto_dealloc() : () -> ()
    
    return %result_matmul, %result_materialized, %cloned_memref : tensor<?x?xf32>, tensor<4x4xf32>, memref<?xf32>
  }

  func.func @auto_dealloc() {
    %c10 = arith.constant 10 : index
    %c100 = arith.constant 100 : index
    %alloc = memref.alloc(%c10) : memref<?xi32>
    %realloc = memref.realloc %alloc(%c100) : memref<?xi32> to memref<?xi32>
    "test.read_buffer"(%realloc) : (memref<?xi32>) -> ()
    return
  }
}