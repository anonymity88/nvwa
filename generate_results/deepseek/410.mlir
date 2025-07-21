module {
  func.func @main(%arg: memref<4x2x3xf32>, %dim: index, %src: memref<10xf32>, %dst: memref<10xf32>, %arg0: f32, %arg1: memref<4xf32>, %c: index) -> (memref<8x3xf32>, memref<8x?xf32, 1>) {
    %collapsed = memref.collapse_shape %arg [[0, 1], [2]] : 
      memref<4x2x3xf32> into memref<8x3xf32>
    
    %alloc_memref = memref.alloc(%dim) : memref<8x?xf32, 1>
    
    %index0 = arith.constant 0 : index
    %index1 = arith.constant 0 : index
    %default_value = memref.load %alloc_memref[%index0, %index1] : memref<8x?xf32, 1>
    
    memref.copy %src, %dst : memref<10xf32> to memref<10xf32>
    
    call @atomicrmw_cast_fold(%arg0, %arg1, %c) : (f32, memref<4xf32>, index) -> ()
    
    return %collapsed, %alloc_memref : memref<8x3xf32>, memref<8x?xf32, 1>
  }

  func.func @atomicrmw_cast_fold(%arg0 : f32, %arg1 : memref<4xf32>, %c : index) {
    %v = memref.cast %arg1 : memref<4xf32> to memref<?xf32>
    %a = memref.atomic_rmw addf %arg0, %v[%c] : (f32, memref<?xf32>) -> f32
    return
  }
}