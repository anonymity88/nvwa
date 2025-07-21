module {
  func.func @main() {
    // First fragment: create dense tensor
    %dim1 = arith.constant 5 : index
    %dim2 = arith.constant 5 : index
    %mem = memref.alloc() : memref<5x5xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %tensor, %token1 = gpu.create_dn_tensor async [%dep1] %mem, %dim1, %dim2 : 
      index, index into memref<5x5xf64>

    // Second fragment: deallocate GPU memory
    %memref = memref.alloc() : memref<8x64xf32, 1>
    %dep2 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %token2 = gpu.dealloc async [%dep2] %memref : memref<8x64xf32, 1>

    // Third fragment: get subgroup size
    %sgSz = gpu.subgroup_size : index

    return
  }
}