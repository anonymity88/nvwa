module {
  func.func @main(%src: memref<64xf32>, %new_size: index, %arg: memref<4xf32>, %arg0: memref<10xf32>, %arg1: memref<10xf32>, %i: index, %j: index) -> (memref<124xf32>, f32) {
    // Operations from first IR fragment
    %new = memref.realloc %src : memref<64xf32> to memref<124xf32>
    %index = arith.constant 0 : index
    %value = memref.load %new[%index] : memref<124xf32>
    memref.assume_alignment %arg, 64 : memref<4xf32>
    %index2 = arith.constant 0 : index
    %value2 = memref.load %arg[%index2] : memref<4xf32>
    memref.copy %arg0, %arg1 : memref<10xf32> to memref<10xf32>
    
    // Call function from second IR fragment
    %loaded_val = call @memref_load(%i, %j) : (index, index) -> f32
    
    return %new, %loaded_val : memref<124xf32>, f32
  }

  func.func @memref_load(%i: index, %j: index) -> f32 {
    %0 = memref.alloca() : memref<4x8xf32>
    %1 = memref.load %0[%i, %j] : memref<4x8xf32>
    return %1 : f32
  }
}