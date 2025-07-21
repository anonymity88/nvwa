module {
  func.func @combined_func(%arg0: i32, %arg1: i32, %arg2: memref<10xi32>, %arg3: index, %arg4: i32, %arg5: memref<16xi32>, %arg6: i32, %arg7: memref<8xi32>) -> (i32, memref<10xi32>, memref<8xi32>) {
    // First perform the atomic compare-swap operation
    %index1 = arith.index_cast %arg3 : index to i32
    amdgpu.raw_buffer_atomic_cmpswap %arg0, %arg1 -> %arg2[%index1] sgprOffset %arg4 : i32 -> memref<10xi32>, i32
    
    // Then load a value from the buffer
    %loaded_value = amdgpu.raw_buffer_load %arg5[%arg6] sgprOffset %arg4 : memref<16xi32>, i32 -> i32
    
    // Use the loaded value for the atomic min operation
    %index2 = arith.index_cast %arg3 : index to i32
    amdgpu.raw_buffer_atomic_umin %loaded_value -> %arg7[%index2] sgprOffset %arg4 : i32 -> memref<8xi32>, i32
    
    return %loaded_value, %arg2, %arg7 : i32, memref<10xi32>, memref<8xi32>
  }
}