module {
  func.func @main() {
    %data = memref.alloc() : memref<2x6xf32>
    %sum = memref.alloc() : memref<10xf32>  // Changed to match expected type
    %mul = memref.alloc() : memref<2xf32>
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    
    // Launch GPU kernel for reductions
    gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %c1, %grid_y = %c1, %grid_z = %c1)
               threads(%tx, %ty, %tz) in (%block_x = %c1, %block_y = %c1, %block_z = %c1) {
      %val = memref.load %data[%bx, %tx] : memref<2x6xf32>
      %reduced0 = gpu.all_reduce add %val uniform {} : (f32) -> (f32)
      memref.store %reduced0, %sum[%bx] : memref<10xf32>
      %reduced1 = gpu.all_reduce mul %val uniform {} : (f32) -> (f32)
      memref.store %reduced1, %mul[%bx] : memref<2xf32>
      gpu.terminator
    }
    
    // Prepare arguments for combined_func
    %f0 = arith.constant 0.0 : f32
    %f1 = arith.constant 1.0 : f32
    %vec = arith.constant dense<0.0> : vector<4xf8E4M3FNUZ>
    %index_buffer = memref.alloc() : memref<8xi32>
    
    // Call combined function
    %packed_result, %updated_sum, %updated_index = call @combined_func(
      %f0, %f1, %vec, %f0, %sum, %c0, %c0_i32, %c0_i32, %index_buffer, %c0, %c0_i32
    ) : (f32, f32, vector<4xf8E4M3FNUZ>, f32, memref<10xf32>, index, i32, i32, memref<8xi32>, index, i32) 
      -> (vector<4xf8E4M3FNUZ>, memref<10xf32>, memref<8xi32>)
    
    return
  }

  func.func @combined_func(
    %arg0: f32, %arg1: f32, %arg2: vector<4xf8E4M3FNUZ>,
    %arg3: f32, %arg4: memref<10xf32>, %arg5: index, %arg6: i32,
    %arg7: i32, %arg8: memref<8xi32>, %arg9: index, %arg10: i32
  ) -> (vector<4xf8E4M3FNUZ>, memref<10xf32>, memref<8xi32>) {
    %packed_result = amdgpu.packed_trunc_2xfp8 %arg0, %arg1 into %arg2 [word 0] : f32 to vector<4xf8E4M3FNUZ> into vector<4xf8E4M3FNUZ>
    
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    %index1 = arith.index_cast %arg5 : index to i32
    amdgpu.raw_buffer_atomic_fmax %arg3 -> %arg4[%index1] sgprOffset %arg6 : f32 -> memref<10xf32>, i32
    
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    %index2 = arith.index_cast %arg9 : index to i32
    amdgpu.raw_buffer_atomic_umin %arg7 -> %arg8[%index2] sgprOffset %arg10 : i32 -> memref<8xi32>, i32
    
    return %packed_result, %arg4, %arg8 : vector<4xf8E4M3FNUZ>, memref<10xf32>, memref<8xi32>
  }
}