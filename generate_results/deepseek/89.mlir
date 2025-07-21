module {
  func.func @main() {
    // Set default device first
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    // First fragment: memory allocation and memset
    %dst = memref.alloc() : memref<10x10xf32>
    %value = arith.constant 0.0 : f32
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token1 = gpu.memset async [%dep1] %dst, %value : memref<10x10xf32>, f32

    // Second fragment: BSR matrix creation
    %brows = arith.constant 10 : index
    %bcols = arith.constant 10 : index
    %bnnz = arith.constant 15 : index
    %rBlockSize = arith.constant 2 : index
    %cBlockSize = arith.constant 2 : index

    %bRowPos = memref.alloc() : memref<6xi32>
    %bColIdxs = memref.alloc() : memref<15xi32>
    %values = memref.alloc() : memref<15xf64>

    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token2 = gpu.create_bsr async [%dep2] 
      %brows, %bcols, %bnnz, %rBlockSize, %cBlockSize, 
      %bRowPos, %bColIdxs, %values : 
        memref<6xi32>, memref<15xi32>, memref<15xf64>

    return
  }
}