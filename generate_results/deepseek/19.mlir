module {
  func.func @combined_func(
    %arg0: f32, %arg1: f32, %arg2: vector<4xf8E4M3FNUZ>,
    %arg3: f32, %arg4: memref<10xf32>, %arg5: index, %arg6: i32,
    %arg7: i32, %arg8: memref<8xi32>, %arg9: index, %arg10: i32
  ) -> (vector<4xf8E4M3FNUZ>, memref<10xf32>, memref<8xi32>) {
    // First operation: pack two f32 values into vector<4xf8E4M3FNUZ>
    %packed_result = amdgpu.packed_trunc_2xfp8 %arg0, %arg1 into %arg2 [word 0] : f32 to vector<4xf8E4M3FNUZ> into vector<4xf8E4M3FNUZ>
    
    // Schedule barrier to ensure packing operation is complete
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    // Convert index for atomic fmax operation
    %index1 = arith.index_cast %arg5 : index to i32
    // Perform atomic fmax operation on f32 values
    amdgpu.raw_buffer_atomic_fmax %arg3 -> %arg4[%index1] sgprOffset %arg6 : f32 -> memref<10xf32>, i32
    
    // Schedule barrier to ensure atomic operation is complete
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    // Convert index for atomic umin operation
    %index2 = arith.index_cast %arg9 : index to i32
    // Perform atomic umin operation on i32 values
    amdgpu.raw_buffer_atomic_umin %arg7 -> %arg8[%index2] sgprOffset %arg10 : i32 -> memref<8xi32>, i32
    
    return %packed_result, %arg4, %arg8 : vector<4xf8E4M3FNUZ>, memref<10xf32>, memref<8xi32>
  }
}