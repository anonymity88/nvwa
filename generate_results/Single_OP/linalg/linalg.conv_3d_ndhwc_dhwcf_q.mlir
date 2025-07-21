module {
  func.func @main(
    %input: tensor<1x5x5x5x3xf32>, 
    %filter: tensor<3x3x3x3x5xf32>, 
    %output: tensor<1x3x3x3x5xf32>, 
    %input_zero_point: tensor<f32>,
    %filter_zero_point: tensor<f32>
  ) -> tensor<1x3x3x3x5xf32> {
    %result = linalg.conv_3d_ndhwc_dhwcf_q 
         {strides = dense<[1, 1, 1]> : tensor<3xi64>,
          dilations = dense<[1, 1, 1]> : tensor<3xi64>} 
         ins(%input, %filter, %input_zero_point, %filter_zero_point : tensor<1x5x5x5x3xf32>, tensor<3x3x3x3x5xf32>, tensor<f32>, tensor<f32>)
         outs(%output : tensor<1x3x3x3x5xf32>) -> tensor<1x3x3x3x5xf32>

    return %result : tensor<1x3x3x3x5xf32>
  }
}