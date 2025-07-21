module {
  // Declare the memref types.
  func.func @main(%src: memref<40 x 128 x f32>,
                  %dst: memref<2 x 1024 x f32>,
                  %i: index, %j: index, %k: index, %l: index) -> () {
    
    // Define the number of elements to transfer
    %num_elements = arith.constant 256 : index
    
    // Define an index for the tag memref
    %idx = arith.constant 0 : index
    
    // Allocate a tag memref to check for completion
    %tag = memref.alloc() : memref<1 x i32>

    // Start a non-blocking DMA operation transferring data from %src to %dst
    memref.dma_start %src[%i, %j], %dst[%k, %l], %num_elements, %tag[%idx] :
      memref<40 x 128 x f32>,
      memref<2 x 1024 x f32>,
      memref<1 x i32>
    
    return
  }
}