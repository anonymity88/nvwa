#map10 = affine_map<(d0, d1) -> (d0 floordiv 8 + d1 floordiv 128)>
#map20 = affine_map<(i)[s0] -> (i + s0)>
#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @main() -> () {
    // Constants and affine.apply operations
    %s = arith.constant 64 : index
    %t = arith.constant 256 : index
    %n = arith.constant 10 : index
    %42 = arith.constant 42 : index
    %result1 = affine.apply #map10(%s, %t)
    %result2 = affine.apply #map20(%42)[%n]

    // Memory allocations
    %D = memref.alloca() : memref<100x100xf32>
    %K = memref.alloca() : memref<3x3xf32>
    %scalar_value = arith.constant 0.0 : f32

    // Initialize D with broadcasted values
    %v0 = vector.broadcast %scalar_value : f32 to vector<8xf32>
    affine.vector_store %v0, %D[3, 7] : memref<100x100xf32>, vector<8xf32>

    // Call convolution function
    %conv_result = func.call @conv_2d(%D, %K) : (memref<100x100xf32>, memref<3x3xf32>) -> (memref<98x98xf32>)

    // Loop with memory operations
    affine.for %i = 0 to 10 {
      %buffer = memref.alloca() : memref<10xi32>
      %value = arith.constant 42 : i32
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }

    return
  }

  func.func @conv_2d(%D : memref<100x100xf32>, %K : memref<3x3xf32>) -> (memref<98x98xf32>) {
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
}