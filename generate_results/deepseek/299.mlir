#map_min = affine_map<(d0, d1) -> (1000, d0 + 512)>
#map_vector = affine_map<(d0, d1) -> (d0, d1)>
#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @main(%arg0: index, %arg1: index, %arg2: memref<3x3xf32>, %arg3: memref<3x3xf32>) -> (index, f32, f32) {
    // Compute min result
    %min_result = affine.min #map_min(%arg0, %arg1)
    
    // Allocate buffers for conv2d
    %D = memref.alloca() : memref<100x100xf32>
    %K = memref.alloca() : memref<3x3xf32>
    
    // Vector load operation
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    %i0 = arith.index_cast %c0 : i32 to index
    %i1 = arith.index_cast %c1 : i32 to index
    %vec = affine.vector_load %D[%i0 + 3, %i1 + 7] : memref<100x100xf32>, vector<8xf32>
    
    // Call conv2d function
    %conv_result = call @conv_2d(%D, %K) : (memref<100x100xf32>, memref<3x3xf32>) -> memref<98x98xf32>
    
    // Call parallel reduction function
    %reduction_results:2 = call @affine_parallel_with_reductions(%arg2, %arg3) : (memref<3x3xf32>, memref<3x3xf32>) -> (f32, f32)
    
    return %min_result, %reduction_results#0, %reduction_results#1 : index, f32, f32
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

  func.func @affine_parallel_with_reductions(%arg0: memref<3x3xf32>, %arg1: memref<3x3xf32>) -> (f32, f32) {
    %0:2 = affine.parallel (%kx, %ky) = (0, 0) to (2, 2) reduce ("addf", "mulf") -> (f32, f32) {
      %1 = affine.load %arg0[%kx, %ky] : memref<3x3xf32>
      %2 = affine.load %arg1[%kx, %ky] : memref<3x3xf32>
      %3 = arith.mulf %1, %2 : f32
      %4 = arith.addf %1, %2 : f32
      affine.yield %3, %4 : f32, f32
    }
    return %0#0, %0#1 : f32, f32
  }
}