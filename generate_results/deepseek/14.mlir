module {
  func.func @combined_func(
      %arg0: f32, %arg1: f32, %arg2: vector<4xf8E4M3FNUZ>,
      %arg3: f32, %arg4: memref<20xf32>, %arg5: index, %arg6: i32,
      %arg7: i32, %arg8: memref<8xi32>, %arg9: index, %arg10: i32
  ) -> (vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>) {
    // First operation: pack two f32 values into vector
    %packed_result = amdgpu.packed_trunc_2xfp8 %arg0, %arg1 into %arg2 [word 0] : f32 to vector<4xf8E4M3FNUZ> into vector<4xf8E4M3FNUZ>
    
    // Convert index for buffer store operation
    %store_index = arith.index_cast %arg5 : index to i32
    // Store f32 value to buffer
    amdgpu.raw_buffer_store %arg3 -> %arg4[%store_index] sgprOffset %arg6 : f32 -> memref<20xf32>, i32
    
    // Convert index for atomic operation
    %atomic_index = arith.index_cast %arg9 : index to i32
    // Perform atomic minimum operation on buffer
    amdgpu.raw_buffer_atomic_umin %arg7 -> %arg8[%atomic_index] sgprOffset %arg10 : i32 -> memref<8xi32>, i32
    
    return %packed_result, %arg4, %arg8 : vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>
  }
}