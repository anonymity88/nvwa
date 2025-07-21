#map = affine_map<(d0, d1) -> (d0 + 3, d1 + 7)>
#map_tag = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> () {
    %mem = memref.alloca() : memref<100x100xf32>
    %tag = memref.alloca() : memref<1xi32>
    %src = memref.alloca() : memref<2048xf32>
    %dst = memref.alloca() : memref<256xf32>
    
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    
    %loaded_val = affine.load %mem[%i0 + 3, %i1 + 7] : memref<100x100xf32>
    
    affine.for %i = 0 to 10 {
      %buffer = memref.alloca() : memref<10xi32>
      %value = arith.constant 42 : i32
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }
    
    %num_elements = arith.constant 128 : index
    affine.dma_wait %tag[%i0], %num_elements : memref<1xi32>
    
    // Call the fusion function
    call @fusion_at_depth0_not_currently_supported() : () -> ()
    
    return
  }

  func.func @fusion_at_depth0_not_currently_supported() {
    %0 = memref.alloc() : memref<10xf32>
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %i0 = 0 to 10 {
      affine.store %cst, %0[%i0] : memref<10xf32>
    }
    affine.for %i1 = 0 to 10 {
      %1 = affine.load %0[%c0] : memref<10xf32>
    }
    return
  }
}