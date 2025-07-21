module {
  func.func @main(
      %a0: memref<2xf32>, %a1: memref<4xi32>, %cond0: i1, %cond1: i1,
      %r0: memref<?xf32>, %r1: memref<f64>, %r2: memref<2xi32>,
      %source: tensor<4x4xf32>, %dest: tensor<4x4xf32>, %dest_memref: memref<4x4xf32>,
      %arg0: index, %arg1: index, %argA: tensor<?x?xf32>, %argB: tensor<?x?xf32>,
      %dealloc_arg0: memref<2xi32>, %dealloc_arg1: memref<2xi32>, %dealloc_arg2: memref<2xi32>
  ) -> (i1, i1, i1, tensor<4x4xf32>, tensor<?x?xf32>, memref<2xi32>, memref<2xi32>, i1, i1) {
    // Main function operations
    %dealloc_results:3 = bufferization.dealloc (%a0, %a1 : memref<2xf32>, memref<4xi32>)
        if (%cond0, %cond1)
        retain (%r0, %r1, %r2 : memref<?xf32>, memref<f64>, memref<2xi32>)

    %materialized_tensor = bufferization.materialize_in_destination %source in %dest
        : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>

    bufferization.materialize_in_destination %source in restrict writable %dest_memref
        : (tensor<4x4xf32>, memref<4x4xf32>) -> ()

    %tensor_alloc = bufferization.alloc_tensor(%arg0, %arg1) : tensor<?x?xf32>
    %matmul_result = linalg.matmul
        ins(%argA, %argB: tensor<?x?xf32>, tensor<?x?xf32>)
        outs(%tensor_alloc: tensor<?x?xf32>) -> tensor<?x?xf32>

    // Call dealloc helper function
    %dealloc_ret:4 = call @dealloc_remove_dealloc_memref_contained_in_retained_with_const_true_condition(
        %dealloc_arg0, %dealloc_arg1, %dealloc_arg2) : 
        (memref<2xi32>, memref<2xi32>, memref<2xi32>) -> (memref<2xi32>, memref<2xi32>, i1, i1)

    return %dealloc_results#0, %dealloc_results#1, %dealloc_results#2, 
           %materialized_tensor, %matmul_result, %dealloc_ret#0, %dealloc_ret#1, %dealloc_ret#2, %dealloc_ret#3 : 
           i1, i1, i1, tensor<4x4xf32>, tensor<?x?xf32>, memref<2xi32>, memref<2xi32>, i1, i1
  }

  func.func @dealloc_remove_dealloc_memref_contained_in_retained_with_const_true_condition(
    %arg0: memref<2xi32>, %arg1: memref<2xi32>, %arg2: memref<2xi32>) -> (memref<2xi32>, memref<2xi32>, i1, i1) {
    %true = arith.constant true
    %0:2 = bufferization.dealloc (%arg0, %arg1, %arg2 : memref<2xi32>, memref<2xi32>, memref<2xi32>) if (%true, %true, %true) retain (%arg0, %arg1 : memref<2xi32>, memref<2xi32>)
    return %arg0, %arg1, %0#0, %0#1 : memref<2xi32>, memref<2xi32>, i1, i1
  }
}