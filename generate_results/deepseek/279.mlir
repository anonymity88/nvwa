#layout = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main(%d1: index, %d2: index, %a: tensor<?x?xf32>, %b: tensor<?x?xf32>, %source: tensor<4x4xf32>, %dest: tensor<4x4xf32>, %dest_memref: memref<4x4xf32>, %arg: tensor<4x?xf32>, %noe: index, %t: tensor<?x?x?xf16>) -> (tensor<?x?xf32>, tensor<4x4xf32>, memref<4x?xf32, #layout, 0>, memref<?x?x?xf16>) {
    %c = bufferization.alloc_tensor(%d1, %d2) : tensor<?x?xf32>
    
    %result_matmul = linalg.matmul
      ins(%a, %b: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%c: tensor<?x?xf32>) -> tensor<?x?xf32>
    
    %c_hint = bufferization.alloc_tensor(%d1, %d2) size_hint = %noe : tensor<?x?xf32>
    
    %result_matmul_hint = linalg.matmul
      ins(%a, %b: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%c_hint: tensor<?x?xf32>) -> tensor<?x?xf32>
    
    %result_materialized = bufferization.materialize_in_destination %source in %dest
      : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>
    
    bufferization.materialize_in_destination %source in restrict writable %dest_memref
      : (tensor<4x4xf32>, memref<4x4xf32>) -> ()
    
    %m = bufferization.to_memref %arg : memref<4x?xf32, #layout, 0>
    
    %memref_result = call @no_interface_no_operands(%t) : (tensor<?x?x?xf16>) -> memref<?x?x?xf16>
    
    return %result_matmul, %result_materialized, %m, %memref_result : tensor<?x?xf32>, tensor<4x4xf32>, memref<4x?xf32, #layout, 0>, memref<?x?x?xf16>
  }

  func.func private @no_interface_no_operands(%t : tensor<?x?x?xf16>) -> memref<?x?x?xf16> {
    %0 = bufferization.to_memref %t : memref<?x?x?xf16>
    return %0 : memref<?x?x?xf16>
  }
}