module {
  func.func @main() {
    // First fragment: set default device
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    // Second fragment: create 2to4 sparse matrix
    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 40 : index
    %mem = memref.alloc() : memref<40xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token1 = gpu.create_2to4_spmat async [%dep1] {PRUNE_AND_CHECK} %rows, %cols, %mem : memref<40xf64>

    // Third fragment: host unregister
    %memref = memref.alloc() : memref<10xi32>
    %unranked_memref = memref.cast %memref : memref<10xi32> to memref<*xi32>
    gpu.host_unregister %unranked_memref : memref<*xi32>

    return
  }
}