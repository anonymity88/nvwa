module {
  func.func @main(
    %a0: memref<2xf32>, %a1: memref<4xi32>, %cond0: i1, %cond1: i1, 
    %r0: memref<?xf32>, %r1: memref<f64>, %r2: memref<2xi32>,
    %source: tensor<4x4xf32>, %dest: tensor<4x4xf32>, %dest_memref: memref<4x4xf32>,
    %arg0: index, %arg1: index, %argA: tensor<?x?xf32>, %argB: tensor<?x?xf32>
  ) -> (i1, i1, i1, tensor<4x4xf32>, tensor<?x?xf32>) {
    %dealloc_results:3 = bufferization.dealloc (%a0, %a1 : memref<2xf32>, memref<4xi32>)
      if (%cond0, %cond1) 
      retain (%r0, %r1, %r2 : memref<?xf32>, memref<f64>, memref<2xi32>)

    %tensor_alloc = bufferization.alloc_tensor(%arg0, %arg1) : tensor<?x?xf32>

    %matmul_result = linalg.matmul
      ins(%argA, %argB: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%tensor_alloc: tensor<?x?xf32>) -> tensor<?x?xf32>

    %materialized_tensor = bufferization.materialize_in_destination %source in %dest
      : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>

    bufferization.materialize_in_destination %source in restrict writable %dest_memref
      : (tensor<4x4xf32>, memref<4x4xf32>) -> ()

    // Call auto_dealloc function
    call @auto_dealloc() : () -> ()

    return %dealloc_results#0, %dealloc_results#1, %dealloc_results#2, 
           %materialized_tensor, %matmul_result : i1, i1, i1, tensor<4x4xf32>, tensor<?x?xf32>
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