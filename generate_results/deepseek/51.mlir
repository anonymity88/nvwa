#layout = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @main(%a0: memref<2xf32>, %a1: memref<4xi32>, %cond0: i1, %cond1: i1, %r0: memref<?xf32>, %r1: memref<f64>, %r2: memref<2xi32>, %arg: tensor<4x?xf32>, %tensor: tensor<1024x1024xf64>) -> (i1, i1, i1, memref<4x?xf32, #layout, 0>) {
    // Dealloc operation with conditions
    %0:3 = bufferization.dealloc (%a0, %a1 : memref<2xf32>, memref<4xi32>)
                if (%cond0, %cond1) 
                retain (%r0, %r1, %r2 : memref<?xf32>, memref<f64>, memref<2xi32>)
    
    // Convert tensor to memref
    %m = bufferization.to_memref %arg : memref<4x?xf32, #layout, 0>
    
    // Deallocate tensor
    bufferization.dealloc_tensor %tensor : tensor<1024x1024xf64>
    
    return %0#0, %0#1, %0#2, %m : i1, i1, i1, memref<4x?xf32, #layout, 0>
  }
}