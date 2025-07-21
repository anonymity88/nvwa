module {
  func.func @main() {
    // First fragment: thread IDs
    %tIdX = gpu.thread_id x
    %tIdY = gpu.thread_id y
    %tIdZ = gpu.thread_id z

    // Second fragment: COO matrix creation
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 20 : index
    %rowIdxs = memref.alloc() : memref<20xindex>
    %colIdxs = memref.alloc() : memref<20xindex>
    %values = memref.alloc() : memref<20xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token1 = gpu.create_coo async [%dep1] %rows, %cols, %nnz, %rowIdxs, %colIdxs, %values : 
      memref<20xindex>, memref<20xindex>, memref<20xf64>

    // Third fragment: memcpy operation
    %src = memref.alloc() : memref<128xf32>
    %dst = memref.alloc() : memref<128xf32>
    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token2 = gpu.memcpy async [%dep2] %dst, %src : memref<128xf32>, memref<128xf32>

    return
  }
}