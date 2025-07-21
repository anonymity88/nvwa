func.func @depthwise_conv_2d_nhwc_hwcm_tensor(%input: tensor<2x4x5x2xf32>, %filter: tensor<2x2x2x3xf32>) -> tensor<2x3x4x2x3xf32> {
  %zero = arith.constant 0.000000e+00 : f32
  %init = tensor.empty() : tensor<2x3x4x2x3xf32>
  %fill = linalg.fill ins(%zero : f32) outs(%init : tensor<2x3x4x2x3xf32>) -> tensor<2x3x4x2x3xf32>
  %0 = linalg.depthwise_conv_2d_nhwc_hwcm
     { dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64> }
     ins(%input, %filter : tensor<2x4x5x2xf32>, tensor<2x2x2x3xf32>)
    outs(%fill : tensor<2x3x4x2x3xf32>) -> tensor<2x3x4x2x3xf32>
  return %0 : tensor<2x3x4x2x3xf32>
}