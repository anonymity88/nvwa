module {
  func.func @main() {
    %leadDim = arith.constant 32 : index     // Leading dimension size of the source matrix
    %i = arith.constant 0 : index             // First index for loading the matrix
    %j = arith.constant 0 : index             // Second index for loading the matrix
    %src = memref.alloc() : memref<32x32xf16, 3>  // Allocate source memref in global/shared memory

    // Performing the subgroup matrix load
    %matrix = gpu.subgroup_mma_load_matrix %src[%i, %j] 
      {leadDimension = 32 : index} 
      : memref<32x32xf16, 3> -> !gpu.mma_matrix<16x16xf16, "AOp"> 

    return
  }
}