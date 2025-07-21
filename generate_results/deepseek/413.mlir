#map = affine_map<(i, j) -> (i, j)>

module attributes {transform.with_named_sequence} {
  func.func @sub_tensor(
    %A: tensor<3x4xf32>, 
    %B: tensor<3x4xf32>, 
    %C_init: tensor<3x4xf32>
  ) -> tensor<3x4xf32> {
    %C = linalg.sub 
         ins(%A, %B : tensor<3x4xf32>, tensor<3x4xf32>)
         outs(%C_init : tensor<3x4xf32>) -> tensor<3x4xf32>
    return %C : tensor<3x4xf32>
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

  func.func @abs_tensor(
    %input: tensor<2x3xf32>, 
    %output: tensor<2x3xf32>
  ) -> tensor<2x3xf32> {
    %0 = linalg.abs
         ins(%input : tensor<2x3xf32>)
         outs(%output : tensor<2x3xf32>) -> tensor<2x3xf32>
    return %0 : tensor<2x3xf32>
  }

  func.func @main(
    %A_sub: tensor<3x4xf32>,
    %B_sub: tensor<3x4xf32>,
    %C_init_sub: tensor<3x4xf32>,
    %min_rng: f64,
    %max_rng: f64,
    %seed_rng: i32,
    %O_rng: tensor<16x32xf32>,
    %input_abs: tensor<2x3xf32>,
    %output_abs: tensor<2x3xf32>,
    %I: memref<?x?xindex>,
    %J: memref<?x?xindex>,
    %matmul_input: tensor<?x?xf32>
  ) -> (tensor<3x4xf32>, tensor<16x32xf32>, tensor<2x3xf32>) {
    %sub_result = call @sub_tensor(%A_sub, %B_sub, %C_init_sub) : 
                  (tensor<3x4xf32>, tensor<3x4xf32>, tensor<3x4xf32>) -> tensor<3x4xf32>
    
    %rng_result = call @fill_rng_2d_tensor(%min_rng, %max_rng, %seed_rng, %O_rng) : 
                  (f64, f64, i32, tensor<16x32xf32>) -> tensor<16x32xf32>
    
    %abs_result = call @abs_tensor(%input_abs, %output_abs) : 
                  (tensor<2x3xf32>, tensor<2x3xf32>) -> tensor<2x3xf32>
    
    linalg.generic {
      indexing_maps = [#map, #map],
      iterator_types = ["parallel", "parallel"]
    } outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
    ^bb0(%arg0: index, %arg1: index):
      %i = linalg.index 0 : index
      %j = linalg.index 1 : index
      linalg.yield %i, %j : index, index
    }

    // Matmul operation for transformation sequence
    %matmul = linalg.matmul ins(%matmul_input, %matmul_input : tensor<?x?xf32>, tensor<?x?xf32>)
              outs(%matmul_input : tensor<?x?xf32>) -> tensor<?x?xf32>
    
    return %sub_result, %rng_result, %abs_result : tensor<3x4xf32>, tensor<16x32xf32>, tensor<2x3xf32>
  }

  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.matmul"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    %tiles, %splits = transform.structured.continuous_tile_sizes %0 { dimension = 1, target_size = 9} : (!transform.any_op) -> !transform.any_op
    %low, %high = transform.structured.split %0 after %splits { dimension = 1, multiway } : !transform.any_op, !transform.any_op
    transform.yield
  }
}