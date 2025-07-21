module {
  func.func @main() {
    // Thread IDs
    %tIdX = gpu.thread_id x
    %tIdY = gpu.thread_id y
    %tIdZ = gpu.thread_id z

    // Sparse matrix operations (COO format)
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 20 : index
    %rowIdxs = memref.alloc() : memref<20xindex>
    %colIdxs = memref.alloc() : memref<20xindex>
    %values = memref.alloc() : memref<20xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token1 = gpu.create_coo async [%dep1] %rows, %cols, %nnz, %rowIdxs, %colIdxs, %values : 
      memref<20xindex>, memref<20xindex>, memref<20xf64>

    // Memory copy operations
    %src = memref.alloc() : memref<128xf32>
    %dst = memref.alloc() : memref<128xf32>
    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token2 = gpu.memcpy async [%dep2] %dst, %src : memref<128xf32>, memref<128xf32>

    // Prepare arguments for m16n8k4_tf32 function
    %arg0 = arith.constant dense<[[1.0], [2.0]]> : vector<2x1xf32>  // Fixed shape to match type
    %arg1 = arith.constant dense<[[3.0]]> : vector<1x1xf32>
    %arg2 = arith.constant dense<[[1.0, 2.0], [3.0, 4.0]]> : vector<2x2xf32>
    
    // Call matrix multiply function
    %mma_result = call @m16n8k4_tf32(%arg0, %arg1, %arg2) : 
      (vector<2x1xf32>, vector<1x1xf32>, vector<2x2xf32>) -> vector<2x2xf32>

    return
  }

  func.func @m16n8k4_tf32(%arg0: vector<2x1xf32>, %arg1: vector<1x1xf32>, %arg2: vector<2x2xf32>) -> vector<2x2xf32> {
    %d = nvgpu.mma.sync (%arg0, %arg1, %arg2) {mmaShape = [16, 8, 4], tf32Enabled} : 
      (vector<2x1xf32>, vector<1x1xf32>, vector<2x2xf32>) -> vector<2x2xf32>
    return %d : vector<2x2xf32>
  }
}