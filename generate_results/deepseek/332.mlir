#map_src = affine_map<(d0, d1) -> (d0 + 3, d1)>
#map_dst = affine_map<(d0, d1) -> (d0 + 7, d1)>
#map_tag = affine_map<(d0) -> (d0)>
#map_store = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>
#map_min1 = affine_map<(d0) -> (2 * d0, 2)>
#map_min2 = affine_map<(d0)[s0] -> (d0, s0)>

module {
  func.func @main(%M: index) -> () {
    %src = memref.alloca() : memref<40x128xf32, 0>
    %dst = memref.alloca() : memref<2x1024xf32, 1>
    %tag = memref.alloca() : memref<1xi32, 2>
    %num_elements = arith.constant 256 : index
    %idx = arith.constant 0 : index

    %memref = memref.alloca() : memref<100x100xf32>
    %v0 = arith.constant 1.0 : f32

    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index

    affine.dma_start %src[%i0 + 3, %i1], %dst[%i0 + 7, %i1], %tag[%idx], %num_elements : 
      memref<40x128xf32, 0>, memref<2x1024xf32, 1>, memref<1xi32, 2>

    affine.store %v0, %memref[%i0 + 3, %i1 + 7] : memref<100x100xf32>

    affine.for %i = 0 to 10 {
      %buffer = memref.alloca() : memref<10xi32>
      %value = arith.constant 42 : i32
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }

    // Call the no_simplify_min_max function
    call @no_simplify_min_max(%M) : (index) -> ()

    return
  }

  func.func @no_simplify_min_max(%M: index) {
    affine.for %i = 0 to 4 {
      affine.for %j = 0 to min #map_min1(%i) {
        "test.foo"() : () -> ()
      }
      affine.for %j = 0 to min #map_min2(%i)[%M] {
        "test.foo"() : () -> ()
      }
    }
    return
  }
}