module {
  func.func @main() -> (vector<8xf16>, memref<10xi32>, f32) {
    // Allocate memory and prepare arguments
    %arg0 = arith.constant dense<0.0> : vector<8xf16>
    %arg1 = arith.constant dense<1.0> : vector<8xf16>
    %arg2 = arith.constant dense<2.0> : vector<8xf16>
    %arg3 = arith.constant 42 : i32
    %arg4 = memref.alloc() : memref<10xi32>
    %arg5 = arith.constant 0 : index
    %arg6 = arith.constant dense<0.0> : vector<4xf8E5M2FNUZ>

    // Call combined function
    %wmma_result, %updated_buffer, %extracted_fp = call @combined_func(
      %arg0, %arg1, %arg2, %arg3, %arg4, %arg5, %arg6
    ) : (vector<8xf16>, vector<8xf16>, vector<8xf16>, i32, memref<10xi32>, index, vector<4xf8E5M2FNUZ>) 
      -> (vector<8xf16>, memref<10xi32>, f32)

    // Prepare arguments for mma_sp_sync_f16_16832
    %mma_arg0 = arith.constant dense<[[0.0, 0.0], [1.0, 1.0], [2.0, 2.0], [3.0, 3.0]]> : vector<4x2xf16>
    %mma_arg1 = arith.constant dense<[[0.0, 0.0], [1.0, 1.0], [2.0, 2.0], [3.0, 3.0]]> : vector<4x2xf16>
    %mma_arg2 = arith.constant dense<[[0.0, 0.0], [1.0, 1.0]]> : vector<2x2xf16>
    %mma_arg3 = arith.constant dense<0> : vector<2xi16>

    // Call MMA function
    %mma_result = call @mma_sp_sync_f16_16832(%mma_arg0, %mma_arg1, %mma_arg2, %mma_arg3) : 
      (vector<4x2xf16>, vector<4x2xf16>, vector<2x2xf16>, vector<2xi16>) -> vector<2x2xf16>

    return %wmma_result, %updated_buffer, %extracted_fp : vector<8xf16>, memref<10xi32>, f32
  }

  func.func @combined_func(
    %arg0: vector<8xf16>, %arg1: vector<8xf16>, %arg2: vector<8xf16>,
    %arg3: i32, %arg4: memref<10xi32>, %arg5: index,
    %arg6: vector<4xf8E5M2FNUZ>
  ) -> (vector<8xf16>, memref<10xi32>, f32) {
    %wmma_result = amdgpu.wmma %arg0 * %arg1 + %arg2 : vector<8xf16>, vector<8xf16>, vector<8xf16>
    
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    %index1 = arith.index_cast %arg5 : index to i32
    
    amdgpu.raw_buffer_atomic_smax %arg3 -> %arg4[%index1] : i32 -> memref<10xi32>, i32
    
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    
    %extracted_fp = amdgpu.ext_packed_fp8 %arg6[2] : vector<4xf8E5M2FNUZ> to f32
    
    return %wmma_result, %arg4, %extracted_fp : vector<8xf16>, memref<10xi32>, f32
  }

  func.func @mma_sp_sync_f16_16832(%arg0: vector<4x2xf16>,
                                   %arg1: vector<4x2xf16>,
                                   %arg2: vector<2x2xf16>,
                                   %arg3: vector<2xi16>) -> vector<2x2xf16> {
    %d = nvgpu.mma.sp.sync(%arg0, %arg1, %arg2) metadata(%arg3) {mmaShape = [16, 8, 32]} :
      (vector<4x2xf16>, vector<4x2xf16>, vector<2x2xf16>) -> vector<2x2xf16>
    return %d : vector<2x2xf16>
  }
}