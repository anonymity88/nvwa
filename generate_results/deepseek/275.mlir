module {
  func.func @main(%value: f32, %memref_4x4: memref<4x4xf32>, %i: index, %j: index, 
                 %arg0: memref<10xf32>, %arg1: memref<10xf32>, %memref_4: memref<4xf32>) -> () {
    // Store operations
    memref.store %value, %memref_4x4[%i, %j] : memref<4x4xf32>
    
    // Copy operation
    memref.copy %arg0, %arg1 : memref<10xf32> to memref<10xf32>
    
    // Alignment check and load
    memref.assume_alignment %memref_4, 64 : memref<4xf32>
    %index = arith.constant 0 : index
    %loaded_value = memref.load %memref_4[%index] : memref<4xf32>
    
    // Store loaded value
    memref.store %loaded_value, %memref_4x4[%i, %j] : memref<4x4xf32>
    
    // Call memref_i32 function
    call @memref_i32() : () -> ()
    
    return
  }

  func.func @memref_i32() {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : i32
    %m = memref.alloc() : memref<4xi32, 1>
    %v = memref.load %m[%c0] : memref<4xi32, 1>
    memref.store %c1, %m[%c0] : memref<4xi32, 1>
    return
  }
}