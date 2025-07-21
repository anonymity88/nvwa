module {
  func.func @main() {
    // First fragment: memcpy operations
    %src = memref.alloc() : memref<128xf32>
    %dst = memref.alloc() : memref<128xf32>
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token = gpu.memcpy async [%dep] %dst, %src : memref<128xf32>, memref<128xf32>

    // Third fragment: subgroup size
    %sgSz = gpu.subgroup_size : index

    // Second fragment: yield operations (moved to end of block)
    %f0 = arith.constant 3.14 : f32
    %f1 = arith.constant 2.71 : f32
    gpu.yield %f0, %f1 : f32, f32
  }
}