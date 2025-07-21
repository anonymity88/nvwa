module {
  func.func @main() {
    // First fragment: subgroup_mma_load_matrix operations
    %leadDim = arith.constant 32 : index
    %i = arith.constant 0 : index
    %j = arith.constant 0 : index
    %src = memref.alloc() : memref<32x32xf16, 3>
    %matrix = gpu.subgroup_mma_load_matrix %src[%i, %j] 
      {leadDimension = 32 : index} 
      : memref<32x32xf16, 3> -> !gpu.mma_matrix<16x16xf16, "AOp">

    // Second fragment: create_bsr operations
    %brows = arith.constant 10 : index
    %bcols = arith.constant 10 : index
    %bnnz = arith.constant 15 : index
    %rBlockSize = arith.constant 2 : index
    %cBlockSize = arith.constant 2 : index
    %bRowPos = memref.alloc() : memref<6xi32>
    %bColIdxs = memref.alloc() : memref<15xi32>
    %values1 = memref.alloc() : memref<15xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat1, %token1 = gpu.create_bsr async [%dep1] 
      %brows, %bcols, %bnnz, %rBlockSize, %cBlockSize, 
      %bRowPos, %bColIdxs, %values1 : 
        memref<6xi32>, memref<15xi32>, memref<15xf64>

    // Third fragment: create_csc operations
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 20 : index
    %colPos = memref.alloc() : memref<11xindex>
    %rowIdxs = memref.alloc() : memref<20xindex>
    %values2 = memref.alloc() : memref<20xf64>
    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat2, %token2 = gpu.create_csc async [%dep2] %rows, %cols, %nnz, %colPos, %rowIdxs, %values2 : 
      memref<11xindex>, memref<20xindex>, memref<20xf64>

    return
  }
}