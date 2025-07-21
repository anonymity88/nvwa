module {
  func.func @combined_func(
    %arg0: i32, 
    %arg1: memref<10xi32>, 
    %arg2: index,
    %arg3: memref<16xi32>, 
    %arg4: i32, 
    %arg5: i32
  ) -> i32 {
    // First perform the atomic max operation
    %index1 = arith.index_cast %arg2 : index to i32
    amdgpu.raw_buffer_atomic_smax %arg0 -> %arg1[%index1] : i32 -> memref<10xi32>, i32
    
    // Insert barrier to ensure atomic operation completes
    amdgpu.lds_barrier
    
    // Then perform the buffer load operation
    %loaded_value = amdgpu.raw_buffer_load %arg3[%arg4] sgprOffset %arg5 : memref<16xi32>, i32 -> i32
    
    return %loaded_value : i32
  }
}