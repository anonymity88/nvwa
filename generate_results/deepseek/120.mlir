#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @mmt4d_tensor(
    %lhs: tensor<4x5x2x3xf32>, 
    %rhs: tensor<4x5x2x3xf32>, 
    %output: tensor<4x4x2x2xf32>
  ) -> tensor<4x4x2x2xf32> {
    %0 = linalg.mmt4d
         ins(%lhs, %rhs : tensor<4x5x2x3xf32>, tensor<4x5x2x3xf32>)
         outs(%output : tensor<4x4x2x2xf32>) -> tensor<4x4x2x2xf32>
    return %0 : tensor<4x4x2x2xf32>
  }

  func.func @fill_rng_2d_tensor(
    %min: f64, 
    %max: f64, 
    %seed: i32, 
    %O: tensor<16x32xf32>
  ) -> tensor<16x32xf32> {
    %0 = linalg.fill_rng_2d 
         ins(%min, %max, %seed: f64, f64, i32) 
         outs(%O : tensor<16x32xf32>) -> tensor<16x32xf32>
    return %0: tensor<16x32xf32>
  }

  func.func @main(
    %lhs_mmt4d: tensor<4x5x2x3xf32>,
    %rhs_mmt4d: tensor<4x5x2x3xf32>,
    %output_mmt4d: tensor<4x4x2x2xf32>,
    %min_rng: f64,
    %max_rng: f64,
    %seed_rng: i32,
    %output_rng: tensor<16x32xf32>,
    %I: memref<?x?xindex>,
    %J: memref<?x?xindex>
  ) -> tensor<4x4x2x2xf32> {
    // Call mmt4d operation
    %mmt4d_result = call @mmt4d_tensor(%lhs_mmt4d, %rhs_mmt4d, %output_mmt4d) 
                    : (tensor<4x5x2x3xf32>, tensor<4x5x2x3xf32>, tensor<4x4x2x2xf32>) -> tensor<4x4x2x2xf32>
    
    // Call fill_rng_2d operation
    %rng_result = call @fill_rng_2d_tensor(%min_rng, %max_rng, %seed_rng, %output_rng)
                 : (f64, f64, i32, tensor<16x32xf32>) -> tensor<16x32xf32>
    
    // Perform generic operation
    linalg.generic {
      indexing_maps = [#map, #map],
      iterator_types = ["parallel", "parallel"]
    } outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
    ^bb0(%arg0: index, %arg1: index):
      %i = linalg.index 0 : index
      %j = linalg.index 1 : index
      linalg.yield %i, %j : index, index
    }
    
    return %mmt4d_result : tensor<4x4x2x2xf32>
  }
}