module {
  func.func @main() {
    // First fragment: set default device
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    // Second fragment: create CSC sparse matrix
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 20 : index
    %colPos = memref.alloc() : memref<11xindex>
    %rowIdxs = memref.alloc() : memref<20xindex>
    %values = memref.alloc() : memref<20xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token1 = gpu.create_csc async [%dep1] %rows, %cols, %nnz, %colPos, %rowIdxs, %values : 
      memref<11xindex>, memref<20xindex>, memref<20xf64>

    // Third fragment: subgroup mma load matrix
    %leadDim = arith.constant 32 : index
    %i = arith.constant 0 : index
    %j = arith.constant 0 : index
    %src = memref.alloc() : memref<32x32xf16, 3>
    %matrix = gpu.subgroup_mma_load_matrix %src[%i, %j] 
      {leadDimension = 32 : index} 
      : memref<32x32xf16, 3> -> !gpu.mma_matrix<16x16xf16, "AOp">

    return
  }
}