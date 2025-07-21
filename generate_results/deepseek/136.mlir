module {
  func.func @main(%arg0: memref<?xf32, 5>, %arg1: memref<5x4xi32, 3>, 
                 %src_copy: memref<10xf32>, %dst_copy: memref<10xf32>,
                 %reshape_src: memref<4x1xf32>, %shape: memref<1xi32>) -> memref<4xf32> {
    // Memory space casts
    %cast1 = memref.memory_space_cast %arg0 : memref<?xf32, 5> to memref<?xf32>
    %cast2 = memref.memory_space_cast %arg1 : memref<5x4xi32, 3> to memref<5x4xi32>
    
    // Copy operation between memrefs
    memref.copy %src_copy, %dst_copy : memref<10xf32> to memref<10xf32>
    
    // Reshape operation
    %reshaped = memref.reshape %reshape_src(%shape) : (memref<4x1xf32>, memref<1xi32>) -> memref<4xf32>
    
    // Use the cast results in some way to create data dependency
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1.0 : f32
    memref.store %c1, %cast1[%c0] : memref<?xf32>
    
    %c0_i32 = arith.constant 0 : i32
    %c0_0 = arith.constant 0 : index
    %c0_1 = arith.constant 0 : index
    memref.store %c0_i32, %cast2[%c0_0, %c0_1] : memref<5x4xi32>
    
    return %reshaped : memref<4xf32>
  }
}