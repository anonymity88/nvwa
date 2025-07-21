module {
  func.func @main() {
    // Constants for the sparse matrix dimensions and block sizes
    %brows = arith.constant 10 : index
    %bcols = arith.constant 10 : index
    %bnnz = arith.constant 15 : index
    %rBlockSize = arith.constant 2 : index
    %cBlockSize = arith.constant 2 : index

    // Allocating memref for BSR format components
    %bRowPos = memref.alloc() : memref<6xi32>      // Example allocation (size might vary)
    %bColIdxs = memref.alloc() : memref<15xi32>   // Example allocation (size might vary)
    %values = memref.alloc() : memref<15xf64>      // Example allocation (size might vary)

    // Assuming a previous async dependency operation
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    
    // Perform the gpu.create_bsr operation to create the sparse matrix asynchronously
    %spmat, %token = gpu.create_bsr async [%dep] 
      %brows, %bcols, %bnnz, %rBlockSize, %cBlockSize, 
      %bRowPos, %bColIdxs, %values : 
        memref<6xi32>, memref<15xi32>, memref<15xf64>

    return
  }
}