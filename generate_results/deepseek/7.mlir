#map_src = affine_map<(d0, d1) -> (d0 + 3, d1)>
#map_dst = affine_map<(d0, d1) -> (d0 + 7, d1)>
#map_tag = affine_map<(d0) -> (d0)>
#map10 = affine_map<(d0, d1) -> (d0 floordiv 8 + d1 floordiv 128)>
#map20 = affine_map<(i)[s0] -> (i + s0)>
#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @main() -> () {
    // DMA setup
    %src = memref.alloca() : memref<40x128xf32, 0>
    %dst = memref.alloca() : memref<2x1024xf32, 1>
    %num_elements = arith.constant 256 : index
    %idx = arith.constant 0 : index
    %tag = memref.alloca() : memref<1xi32, 2>
    
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i = arith.index_cast %c0 : i32 to index
    %j = arith.index_cast %c1 : i32 to index
    %k = arith.index_cast %c0 : i32 to index
    %l = arith.index_cast %c1 : i32 to index

    // Affine apply operations
    %s = arith.constant 64 : index
    %t = arith.constant 256 : index
    %n = arith.constant 10 : index
    %42 = arith.constant 42 : index
    %result1 = affine.apply #map10(%s, %t)
    %result2 = affine.apply #map20(%42)[%n]

    // Convolution setup
    %D = memref.alloca() : memref<100x100xf32>
    %K = memref.alloca() : memref<3x3xf32>
    %scalar_value = arith.constant 0.0 : f32
    
    // Store a broadcasted value in the 2D array
    %v0 = vector.broadcast %scalar_value : f32 to vector<8xf32>
    affine.vector_store %v0, %D[3, 7] : memref<100x100xf32>, vector<8xf32>

    // Call convolution function
    %conv_result = func.call @conv_2d(%D, %K) : (memref<100x100xf32>, memref<3x3xf32>) -> (memref<98x98xf32>)

    // DMA operation
    affine.dma_start %src[%i + 3, %j], %dst[%k + 7, %l], %tag[%idx], %num_elements : 
      memref<40x128xf32, 0>, memref<2x1024xf32, 1>, memref<1xi32, 2>

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