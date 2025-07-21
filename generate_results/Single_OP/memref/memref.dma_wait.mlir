module {
  func.func @main(%tag: memref<1 x i32>, %num_elements: index) -> () {
    // Index for the tag memref
    %index = arith.constant 0 : index

    // Wait for the completion of the DMA operation
    memref.dma_wait %tag[%index], %num_elements : memref<1 x i32>
    
    return
  }
}