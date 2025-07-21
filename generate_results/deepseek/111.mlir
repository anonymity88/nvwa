#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @depthwise_conv_2d_nhwc_hwc_q(
    %input: tensor<1x28x28x3xf32>, 
    %filter: tensor<3x3x3xf32>, 
    %input_zero_point: tensor<f32>, 
    %filter_zero_point: tensor<f32>, 
    %output: tensor<1x26x26x3xf32>
  ) -> tensor<1x26x26x3xf32> {
    %result = linalg.depthwise_conv_2d_nhwc_hwc_q 
        {strides = dense<[1, 1]> : tensor<2xi64>, 
         dilations = dense<[1, 1]> : tensor<2xi64>}
        ins(%input, %filter, %input_zero_point, %filter_zero_point : 
            tensor<1x28x28x3xf32>, tensor<3x3x3xf32>, tensor<f32>, tensor<f32>)
        outs(%output : tensor<1x26x26x3xf32>) 
        -> tensor<1x26x26x3xf32>
    return %result : tensor<1x26x26x3xf32>
  }

  func.func @batch_matmul_tensor(
    %a: tensor<2x3x4xf32>, 
    %b: tensor<2x4x5xf32>, 
    %output: tensor<2x3x5xf32>
  ) -> tensor<2x3x5xf32> {
    %0 = linalg.batch_matmul 
         ins(%a, %b : tensor<2x3x4xf32>, tensor<2x4x5xf32>) 
         outs(%output : tensor<2x3x5xf32>) -> tensor<2x3x5xf32>
    return %0 : tensor<2x3x5xf32>
  }

  func.func @add_tensor(
    %A: tensor<3x4xf32>, 
    %B: tensor<3x4xf32>, 
    %C_init: tensor<3x4xf32>
  ) -> tensor<3x4xf32> {
    %C = linalg.add 
         ins(%A, %B : tensor<3x4xf32>, tensor<3x4xf32>)
         outs(%C_init : tensor<3x4xf32>) -> tensor<3x4xf32>
    return %C : tensor<3x4xf32>
  }

  func.func @main(
    %input_conv: tensor<1x28x28x3xf32>, 
    %filter_conv: tensor<3x3x3xf32>, 
    %input_zero_point: tensor<f32>, 
    %filter_zero_point: tensor<f32>, 
    %output_conv: tensor<1x26x26x3xf32>,
    %a_matmul: tensor<2x3x4xf32>, 
    %b_matmul: tensor<2x4x5xf32>, 
    %output_matmul: tensor<2x3x5xf32>,
    %A_add: tensor<3x4xf32>, 
    %B_add: tensor<3x4xf32>, 
    %C_init_add: tensor<3x4xf32>,
    %I: memref<?x?xindex>, 
    %J: memref<?x?xindex>
  ) -> tensor<1x26x26x3xf32> {
    // Call depthwise convolution
    %conv_result = call @depthwise_conv_2d_nhwc_hwc_q(
      %input_conv, %filter_conv, %input_zero_point, %filter_zero_point, %output_conv
    ) : (tensor<1x28x28x3xf32>, tensor<3x3x3xf32>, tensor<f32>, tensor<f32>, tensor<1x26x26x3xf32>) -> tensor<1x26x26x3xf32>

    // Call batch matrix multiplication
    %matmul_result = call @batch_matmul_tensor(
      %a_matmul, %b_matmul, %output_matmul
    ) : (tensor<2x3x4xf32>, tensor<2x4x5xf32>, tensor<2x3x5xf32>) -> tensor<2x3x5xf32>

    // Call elementwise addition
    %add_result = call @add_tensor(
      %A_add, %B_add, %C_init_add
    ) : (tensor<3x4xf32>, tensor<3x4xf32>, tensor<3x4xf32>) -> tensor<3x4xf32>

    // Generic operation
    linalg.generic {
      indexing_maps = [#map, #map],
      iterator_types = ["parallel", "parallel"]
    } outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
    ^bb0(%arg0: index, %arg1: index):
      %i = linalg.index 0 : index
      %j = linalg.index 1 : index
      linalg.yield %i, %j : index, index
    }

    return %conv_result : tensor<1x26x26x3xf32>
  }
}