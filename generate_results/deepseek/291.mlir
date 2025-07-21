#map_load = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>
#map_prefetch = affine_map<(d0, d1) -> (d0, d1)>
#map_tag = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> () {
    %mem1 = memref.alloca() : memref<100x100xf32>
    %mem2 = memref.alloca() : memref<400x400xi32>
    %tag = memref.alloca() : memref<1xi32>
    %src = memref.alloca() : memref<2048xf32>
    %dst = memref.alloca() : memref<256xf32>

    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %num_elements = arith.constant 128 : index
    %idx = arith.constant 0 : index

    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    %j0 = arith.index_cast %c0 : i32 to index
    %j1 = arith.index_cast %c1 : i32 to index

    %loaded_val = affine.load %mem1[%i0 + 3, %i1 + 7] : memref<100x100xf32>

    affine.prefetch %mem2[%i0, %i1 + 5], read, locality<3>, data : memref<400x400xi32>

    affine.dma_wait %tag[%idx], %num_elements : memref<1xi32>

    memref.store %loaded_val, %dst[%j0] : memref<256xf32>

    // Call the affine_apply function with some indices
    %a = arith.constant 5 : index
    %b = arith.constant 7 : index
    %result = call @affine_apply(%a, %b) : (index, index) -> index

    return
  }

  func.func @affine_apply(%a: index, %b: index) -> index {
    %0 = affine.apply affine_map<()[s0, s1] -> (s0 + s1)>()[%a, %b]
    %1 = "test.reify_bound"(%0) : (index) -> (index)
    return %1 : index
  }
}