module {
  func.func @main(
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
}