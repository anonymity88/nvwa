module {
  func.func @combined_func(
    %arg0: vector<8xf16>, %arg1: vector<8xf16>, %arg2: vector<8xf16>,
    %arg3: i32, %arg4: memref<10xi32>, %arg5: index,
    %arg6: vector<4xf8E5M2FNUZ>
  ) -> (vector<8xf16>, memref<10xi32>, f32) {
    // Perform WMMA operation
    %wmma_result = amdgpu.wmma %arg0 * %arg1 + %arg2 : vector<8xf16>, vector<8xf16>, vector<8xf16>
    
    // Schedule barrier to ensure WMMA operation is complete
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    // Convert index for atomic smax operation
    %index1 = arith.index_cast %arg5 : index to i32
    
    // Perform atomic smax operation
    amdgpu.raw_buffer_atomic_smax %arg3 -> %arg4[%index1] : i32 -> memref<10xi32>, i32
    
    // Schedule barrier to ensure atomic operation is complete
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    // Extract packed fp8 value to f32
    %extracted_fp = amdgpu.ext_packed_fp8 %arg6[2] : vector<4xf8E5M2FNUZ> to f32
    
    return %wmma_result, %arg4, %extracted_fp : vector<8xf16>, memref<10xi32>, f32
  }
}