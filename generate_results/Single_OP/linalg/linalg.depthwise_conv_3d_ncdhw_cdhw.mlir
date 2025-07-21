func.func @depthwise_conv_3d_ncdhw_cdhw(%input: tensor<2x6x6x13x12xf32>, %filter: tensor<6x2x1x3xf32>) -> tensor<2x6x3x13x4xf32> {
  %zero = arith.constant 0.000000e+00 : f32
  %init = tensor.empty() : tensor<2x6x3x13x4xf32>
  %fill = linalg.fill ins(%zero : f32) outs(%init : tensor<2x6x3x13x4xf32>) -> tensor<2x6x3x13x4xf32>
  // CHECK: depthwise_conv_3d_ncdhw_cdhw
  %0 = linalg.depthwise_conv_3d_ncdhw_cdhw {dilations = dense<1> : tensor<3xi64>, strides = dense<[2, 1, 3]> : tensor<3xi64>}
    ins(%input, %filter : tensor<2x6x6x13x12xf32>, tensor<6x2x1x3xf32>)
    outs(%fill : tensor<2x6x3x13x4xf32>) -> tensor<2x6x3x13x4xf32>
  return %0 : tensor<2x6x3x13x4xf32>
}