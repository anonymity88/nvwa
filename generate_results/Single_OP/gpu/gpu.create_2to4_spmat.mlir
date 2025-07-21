module {
  func.func @main() {
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 40 : index  // Set a constant for number of non-zero entries

    %mem = memref.alloc() : memref<40xf64>  // Allocate memref with specific size

    // Assuming a previous async dependency operation
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    
    %spmat, %token = gpu.create_2to4_spmat async [%dep] {PRUNE_AND_CHECK} %rows, %cols, %mem : 
      memref<40xf64>

    return
  }
}