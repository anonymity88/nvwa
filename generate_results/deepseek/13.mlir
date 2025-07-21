module {
  func.func @combined_func(%arg0: vector<4xf8E5M2FNUZ>, %arg1: f32, %arg2: memref<20xf32>, %arg3: index, %arg4: i32) -> (f32, memref<20xf32>) {
    // Schedule barrier to ensure operations are complete
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    // Extracting element from the packed vector and converting to f32
    %extracted_f32 = amdgpu.ext_packed_fp8 %arg0[2] : vector<4xf8E5M2FNUZ> to f32
    
    // Convert index for store operation
    %index1 = arith.index_cast %arg3 : index to i32
    
    // Store the extracted f32 value to the buffer
    amdgpu.raw_buffer_store %extracted_f32 -> %arg2[%index1] sgprOffset %arg4 : f32 -> memref<20xf32>, i32
    
    // Also store the input f32 value to demonstrate data flow
    amdgpu.raw_buffer_store %arg1 -> %arg2[%index1] sgprOffset %arg4 : f32 -> memref<20xf32>, i32
    
    return %extracted_f32, %arg2 : f32, memref<20xf32>
  }
}