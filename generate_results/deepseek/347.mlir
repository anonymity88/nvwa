#map_min = affine_map<(d0, d1) -> (1000, d0 + 512)>
#map_max = affine_map<(d0) -> (1000, d0 + 512)>
#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @main(%arg0: index, %arg1: index) -> () {
    %min_result = affine.min #map_min(%arg0, %arg1)
    
    %c0 = arith.constant 0 : i32
    %max_i = arith.index_cast %c0 : i32 to index
    %maxVal = affine.max #map_max(%max_i)
    
    %D = memref.alloca() : memref<100x100xf32>
    %K = memref.alloca() : memref<3x3xf32>
    
    %scalar_value = arith.constant 0.0 : f32
    %v0 = vector.broadcast %scalar_value : f32 to vector<8xf32>
    affine.vector_store %v0, %D[3, 7] : memref<100x100xf32>, vector<8xf32>
    
    // Call vector_load_2d to demonstrate vector loading
    call @vector_load_2d(%D) : (memref<100x100xf32>) -> ()
    
    %conv_result = call @conv_2d(%D, %K) : (memref<100x100xf32>, memref<3x3xf32>) -> memref<98x98xf32>
    
    return
  }
  
  func.func @conv_2d(%D : memref<100x100xf32>, %K : memref<3x3xf32>) -> memref<98x98xf32> {
    %O = memref.alloca() : memref<98x98xf32>
    
    affine.parallel (%x, %y) = (0, 0) to (98, 98) {
      %0 = affine.parallel (%kx, %ky) = (0, 0) to (2, 2) reduce ("addf") -> f32 {
        %1 = affine.load %D[%x + %kx, %y + %ky] : memref<100x100xf32>
        %2 = affine.load %K[%kx, %ky] : memref<3x3xf32>
        %3 = arith.mulf %1, %2 : f32
        affine.yield %3 : f32
      }
      affine.store %0, %O[%x, %y] : memref<98x98xf32>
    }
    
    return %O : memref<98x98xf32>
  }

  func.func @vector_load_2d(%0: memref<100x100xf32>) {
    affine.for %i0 = 0 to 16 step 2 {
      affine.for %i1 = 0 to 16 step 8 {
        %1 = affine.vector_load %0[%i0, %i1] : memref<100x100xf32>, vector<2x8xf32>
      }
    }
    return
  }
}