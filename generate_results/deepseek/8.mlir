#map = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>
#map_tag = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> () {
    // Allocate memory for various operations
    %mem = memref.alloca() : memref<100x100xf32>
    %tag = memref.alloca() : memref<1xi32>
    %src = memref.alloca() : memref<2048xf32>
    %dst = memref.alloca() : memref<256xf32>
    
    // Constants and index casts
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    
    // Affine load operation
    %loaded_val = affine.load %mem[%i0 + 3, %i1 + 7] : memref<100x100xf32>
    
    // Loop with memory operations
    affine.for %i = 0 to 10 {
      %buffer = memref.alloca() : memref<10xi32>
      %value = arith.constant 42 : i32
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }
    
    // DMA wait operation
    %num_elements = arith.constant 128 : index
    affine.dma_wait %tag[%i0], %num_elements : memref<1xi32>
    
    return
  }
}