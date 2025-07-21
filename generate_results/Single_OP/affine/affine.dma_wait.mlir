#map_tag = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> () {
    // Allocate tag
    %tag = memref.alloca() : memref<1xi32>
    
    // Allocate source and destination buffers
    %src = memref.alloca() : memref<2048xf32>
    %dst = memref.alloca() : memref<256xf32>

    // Example indices for source and destination (these would typically come from loop indices)
    %i = arith.constant 0 : index
    %j = arith.constant 0 : index
    %k = arith.constant 0 : index
    %l = arith.constant 0 : index
    
    // Number of elements to wait for
    %num_elements = arith.constant 128 : index

    // Corrected dma_wait operation with matching memref type
    affine.dma_wait %tag[%i], %num_elements : memref<1xi32>

    return
  }
}