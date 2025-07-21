module {
  func.func @main(%tag: memref<1xi32>, %num_elements: index, %arg0: memref<*xf32>, %arg1: memref<?x?xf32>, %arg: memref<4xf32>) -> (index, index) {
    // DMA wait operation
    %index = arith.constant 0 : index
    memref.dma_wait %tag[%index], %num_elements : memref<1xi32>

    // Memory alignment assumption and load
    memref.assume_alignment %arg, 64 : memref<4xf32>
    %value = memref.load %arg[%index] : memref<4xf32>

    // Get ranks of input memrefs
    %rank0 = memref.rank %arg0 : memref<*xf32>
    %rank1 = memref.rank %arg1 : memref<?x?xf32>

    return %rank0, %rank1 : index, index
  }
}