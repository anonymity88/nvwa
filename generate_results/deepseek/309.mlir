module {
  func.func @main() {
    // GPU device setup and sparse matrix creation
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    %rows = arith.constant 10 : index
    %cols = arith.constant 10 : index
    %nnz = arith.constant 40 : index
    %mem = memref.alloc() : memref<40xf64>
    %dep1 = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %spmat, %token1 = gpu.create_2to4_spmat async [%dep1] {PRUNE_AND_CHECK} %rows, %cols, %mem : memref<40xf64>

    // Memory management operations
    %memref = memref.alloc() : memref<10xi32>
    %unranked_memref = memref.cast %memref : memref<10xi32> to memref<*xi32>
    gpu.host_unregister %unranked_memref : memref<*xi32>

    // Prepare matrices for matmul
    %matA = memref.alloc() : memref<32x32xf32>
    %matB = memref.alloc() : memref<32x32xf32>
    %matC = memref.alloc() : memref<32x32xf32>

    // Call matrix multiplication function
    call @improperly_sized_grid_dims(%matA, %matB, %matC) : (memref<32x32xf32>, memref<32x32xf32>, memref<32x32xf32>) -> ()

    return
  }

  func.func public @improperly_sized_grid_dims(%arg0: memref<32x32xf32>, %arg1: memref<32x32xf32>, %arg2: memref<32x32xf32>) {
    scf.forall (%arg3, %arg4) in (1, 1) {
      linalg.matmul ins(%arg0, %arg1 : memref<32x32xf32>, memref<32x32xf32>) outs(%arg2 : memref<32x32xf32>)
    } {mapping = [#gpu.block<x>, #gpu.block<y>]}
    return
  }
}