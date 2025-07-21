module {
  func.func @main(%input: tensor<1x28x28x3xi8>, %kernel: tensor<3x3x3x8xi8>, %input_zero_point: i32, %kernel_zero_point: i32, %output: tensor<1x26x26x8xi32>) -> tensor<1x26x26x8xi32> {
    %result = linalg.conv_2d_nhwc_hwcf_q
        {strides = dense<[1, 1]> : tensor<2xi64>, dilations = dense<[1, 1]> : tensor<2xi64>}
        ins(%input, %kernel, %input_zero_point, %kernel_zero_point : tensor<1x28x28x3xi8>, tensor<3x3x3x8xi8>, i32, i32)
        outs(%output : tensor<1x26x26x8xi32>) -> tensor<1x26x26x8xi32>

    return %result : tensor<1x26x26x8xi32>
  }
}