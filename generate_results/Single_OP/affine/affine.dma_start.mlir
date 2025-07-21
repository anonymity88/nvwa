#map_src = affine_map<(d0, d1) -> (d0 + 3, d1)>
#map_dst = affine_map<(d0, d1) -> (d0 + 7, d1)>
#map_tag = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> () {
    %src = memref.alloca() : memref<40x128xf32, 0>
    %dst = memref.alloca() : memref<2x1024xf32, 1>
    %num_elements = arith.constant 256 : index
    %idx = arith.constant 0 : index
    %tag = memref.alloca() : memref<1xi32, 2> // Adjusted dimension here

    // Initialize loop indices as constant integers
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32

    // Cast constants to index type
    %i = arith.index_cast %c0 : i32 to index
    %j = arith.index_cast %c1 : i32 to index
    %k = arith.index_cast %c0 : i32 to index
    %l = arith.index_cast %c1 : i32 to index

    // Start a DMA operation
    affine.dma_start %src[%i + 3, %j], %dst[%k + 7, %l], %tag[%idx], %num_elements : 
      memref<40x128xf32, 0>, memref<2x1024xf32, 1>, memref<1xi32, 2>

    return
  }
}