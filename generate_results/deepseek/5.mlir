#map_src = affine_map<(d0, d1) -> (d0 + 3, d1)>
#map_dst = affine_map<(d0, d1) -> (d0 + 7, d1)>
#map_tag = affine_map<(d0) -> (d0)>
#map_store = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>

module {
  func.func @main() -> () {
    // Allocate memory for DMA operation
    %src = memref.alloca() : memref<40x128xf32, 0>
    %dst = memref.alloca() : memref<2x1024xf32, 1>
    %tag = memref.alloca() : memref<1xi32, 2>
    %num_elements = arith.constant 256 : index
    %idx = arith.constant 0 : index

    // Allocate memory for affine.store operation
    %memref = memref.alloca() : memref<100x100xf32>
    %v0 = arith.constant 1.0 : f32

    // Constants and index casts
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index

    // DMA operation
    affine.dma_start %src[%i0 + 3, %i1], %dst[%i0 + 7, %i1], %tag[%idx], %num_elements : 
      memref<40x128xf32, 0>, memref<2x1024xf32, 1>, memref<1xi32, 2>

    // Affine store operation
    affine.store %v0, %memref[%i0 + 3, %i1 + 7] : memref<100x100xf32>

    // Loop with buffer allocation and store
    affine.for %i = 0 to 10 {
      %buffer = memref.alloca() : memref<10xi32>
      %value = arith.constant 42 : i32
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }

    return
  }
}