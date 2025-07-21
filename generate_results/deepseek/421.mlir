module {
  func.func @main(%arg0: memref<?x?xf32>, %arg1: memref<4xf32>, %arg2: memref<12x4xf32, strided<[4, 1], offset: 5>>,
                 %d: index, %s: index, %src: memref<64xf32>, %new_size: index, %shape: memref<1xindex>) -> (memref<8x?xf32>, memref<124xf32>, memref<?xi32>) {
    // Original operations from first IR
    %cast1 = memref.cast %arg0 : memref<?x?xf32> to memref<4x4xf32>
    %cast2 = memref.cast %arg1 : memref<4xf32> to memref<?xf32>
    %cast3 = memref.cast %arg2 : memref<12x4xf32, strided<[4, 1], offset: 5>> to 
                                memref<12x4xf32, strided<[?, ?], offset: ?>>

    %alloc_memref = memref.alloca(%d) : memref<8x?xf32>

    %realloc_memref = memref.realloc %src : memref<64xf32> to memref<124xf32>
    
    %index = arith.constant 0 : index
    %value = memref.load %realloc_memref[%index] : memref<124xf32>

    // Create a properly allocated memref for reshape operation
    %dim0 = memref.dim %arg0, %index : memref<?x?xf32>
    %dim1 = memref.dim %arg0, %index : memref<?x?xf32>
    %reshaped_input = memref.alloc(%dim0, %dim1) : memref<?x?xi32>
    
    // Convert f32 memref to i32 for reshape operation
    %c0_i32 = arith.constant 0 : i32
    affine.for %i = 0 to %dim0 {
      affine.for %j = 0 to %dim1 {
        %val = memref.load %arg0[%i, %j] : memref<?x?xf32>
        %int_val = arith.fptosi %val : f32 to i32
        memref.store %int_val, %reshaped_input[%i, %j] : memref<?x?xi32>
      }
    }

    // Call reshape function with properly typed input
    %reshaped = call @memref.reshape_index(%reshaped_input, %shape) : (memref<?x?xi32>, memref<1xindex>) -> memref<?xi32>

    return %alloc_memref, %realloc_memref, %reshaped : memref<8x?xf32>, memref<124xf32>, memref<?xi32>
  }

  func.func @memref.reshape_index(%arg0: memref<?x?xi32>, %shape: memref<1xindex>) -> memref<?xi32> {
    %1 = memref.reshape %arg0(%shape) : (memref<?x?xi32>, memref<1xindex>) -> memref<?xi32>
    return %1 : memref<?xi32>
  }
}