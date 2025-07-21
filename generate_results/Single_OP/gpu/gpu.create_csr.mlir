module {
  func.func @main() {
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 20 : index

    %rowPos = memref.alloc() : memref<11xindex>
    %colIdxs = memref.alloc() : memref<20xindex>
    %values = memref.alloc() : memref<20xf64>

    // Assuming a previous async dependency operation
    // This would typically come from a preceding async operation
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token = gpu.create_csr async [%dep] %rows, %cols, %nnz, %rowPos, %colIdxs, %values : 
      memref<11xindex>, memref<20xindex>, memref<20xf64>

    return
  }
}