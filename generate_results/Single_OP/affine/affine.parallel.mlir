#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @conv_2d(%D : memref<100x100xf32>, %K : memref<3x3xf32>) -> (memref<98x98xf32>) {
    %O = memref.alloca() : memref<98x98xf32>
    
    affine.parallel (%x, %y) = (0, 0) to (98, 98) {
      // Inner parallel loop using reduction
      %0 = affine.parallel (%kx, %ky) = (0, 0) to (2, 2) reduce ("addf") -> f32 {
        %1 = affine.load %D[%x + %kx, %y + %ky] : memref<100x100xf32>
        %2 = affine.load %K[%kx, %ky] : memref<3x3xf32>
        %3 = arith.mulf %1, %2 : f32
        affine.yield %3 : f32
      }
      // Store the accumulated result from the inner parallel loop to output
      affine.store %0, %O[%x, %y] : memref<98x98xf32>
    }
    
    return %O : memref<98x98xf32>
  }
}