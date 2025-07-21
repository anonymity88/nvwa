func.func @generalize_pooling_nhwc_max_f32(%input : tensor<1x4x16x1xf32>, %shape: tensor<2x2xf32>, %output: tensor<1x2x4x1xf32>) -> tensor<1x2x4x1xf32> {
  %0 = linalg.pooling_nhwc_max {dilations = dense<[1, 2]> : tensor<2xi64>, strides = dense<[2, 4]> : tensor<2xi64>}
    ins(%input, %shape : tensor<1x4x16x1xf32>, tensor<2x2xf32>) outs(%output : tensor<1x2x4x1xf32>) -> tensor<1x2x4x1xf32>
  return %0: tensor<1x2x4x1xf32>
}