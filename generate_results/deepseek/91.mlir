module {
  func.func @main() {
    // First fragment: num_subgroups operation
    %numSg = gpu.num_subgroups : index

    // Second fragment: create_2to4_spmat operation
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 40 : index
    %mem = memref.alloc() : memref<40xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat1, %token1 = gpu.create_2to4_spmat async [%dep1] {PRUNE_AND_CHECK} %rows, %cols, %mem : memref<40xf64>

    // Third fragment: create_bsr operation
    %brows = arith.constant 10 : index
    %bcols = arith.constant 10 : index
    %bnnz = arith.constant 15 : index
    %rBlockSize = arith.constant 2 : index
    %cBlockSize = arith.constant 2 : index
    %bRowPos = memref.alloc() : memref<6xi32>
    %bColIdxs = memref.alloc() : memref<15xi32>
    %values = memref.alloc() : memref<15xf64>
    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat2, %token2 = gpu.create_bsr async [%dep2] 
      %brows, %bcols, %bnnz, %rBlockSize, %cBlockSize, 
      %bRowPos, %bColIdxs, %values : 
        memref<6xi32>, memref<15xi32>, memref<15xf64>

    return
  }
}