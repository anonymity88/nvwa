module {
  func.func @main() -> (vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>, f32, f32) {
    // Prepare arguments for combined_func
    %f0 = arith.constant 0.0 : f32
    %f1 = arith.constant 1.0 : f32
    %vec = arith.constant dense<0.0> : vector<4xf8E4M3FNUZ>
    %buffer_f32 = memref.alloc() : memref<20xf32>
    %buffer_i32 = memref.alloc() : memref<8xi32>
    %c0 = arith.constant 0 : index
    %c0_i32 = arith.constant 0 : i32
    
    // Call combined function
    %packed_result, %updated_f32_buffer, %updated_i32_buffer = call @combined_func(
      %f0, %f1, %vec, %f0, %buffer_f32, %c0, %c0_i32, %c0_i32, %buffer_i32, %c0, %c0_i32
    ) : (f32, f32, vector<4xf8E4M3FNUZ>, f32, memref<20xf32>, index, i32, i32, memref<8xi32>, index, i32) 
      -> (vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>)
    
    // Call GPU shuffle function
    %shfl, %shfli = call @gpu_shuffle() : () -> (f32, f32)
    
    return %packed_result, %updated_f32_buffer, %updated_i32_buffer, %shfl, %shfli : 
      vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>, f32, f32
  }

  func.func @combined_func(
    %arg0: f32, %arg1: f32, %arg2: vector<4xf8E4M3FNUZ>,
    %arg3: f32, %arg4: memref<20xf32>, %arg5: index, %arg6: i32,
    %arg7: i32, %arg8: memref<8xi32>, %arg9: index, %arg10: i32
  ) -> (vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>) {
    %packed_result = amdgpu.packed_trunc_2xfp8 %arg0, %arg1 into %arg2 [word 0] : f32 to vector<4xf8E4M3FNUZ> into vector<4xf8E4M3FNUZ>
    
    %store_index = arith.index_cast %arg5 : index to i32
    amdgpu.raw_buffer_store %arg3 -> %arg4[%store_index] sgprOffset %arg6 : f32 -> memref<20xf32>, i32
    
    %atomic_index = arith.index_cast %arg9 : index to i32
    amdgpu.raw_buffer_atomic_umin %arg7 -> %arg8[%atomic_index] sgprOffset %arg10 : i32 -> memref<8xi32>, i32
    
    return %packed_result, %arg4, %arg8 : vector<4xf8E4M3FNUZ>, memref<20xf32>, memref<8xi32>
  }

  func.func @gpu_shuffle() -> (f32, f32) {
    %arg0 = arith.constant 1.0 : f32
    %arg1 = arith.constant 4 : i32
    %arg2 = arith.constant 23 : i32
    %shfl, %pred = gpu.shuffle xor %arg0, %arg1, %arg2 : f32
    %shfli, %predi = gpu.shuffle idx %arg0, %arg1, %arg2 : f32
    return %shfl, %shfli : f32, f32
  }
}