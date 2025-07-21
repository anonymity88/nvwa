module {
  func.func @main() -> f32 {
    // Main function setup
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    // Sparse matrix setup
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 20 : index
    %colPos = memref.alloc() : memref<11xindex>
    %rowIdxs = memref.alloc() : memref<20xindex>
    %values = memref.alloc() : memref<20xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token1 = gpu.create_csc async [%dep1] %rows, %cols, %nnz, %colPos, %rowIdxs, %values : 
      memref<11xindex>, memref<20xindex>, memref<20xf64>

    // Matrix setup
    %leadDim = arith.constant 32 : index
    %i = arith.constant 0 : index
    %j = arith.constant 0 : index
    %src = memref.alloc() : memref<32x32xf16, 3>
    %matrix = gpu.subgroup_mma_load_matrix %src[%i, %j] 
      {leadDimension = 32 : index} 
      : memref<32x32xf16, 3> -> !gpu.mma_matrix<16x16xf16, "AOp">

    // Prepare arguments for row_bcast_dpp_f32
    %arg0 = arith.constant 1.0 : f32
    %arg1 = arith.constant 2.0 : f32
    %result = call @row_bcast_dpp_f32(%arg0, %arg1) : (f32, f32) -> f32

    return %result : f32
  }

  func.func @row_bcast_dpp_f32(%arg0: f32, %arg1: f32) -> f32 {
    %0 = amdgpu.dpp %arg0 %arg1 row_bcast_15 { bound_ctrl = true } : f32
    return %0 : f32
  }
}