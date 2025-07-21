func.func @generalize_pooling_nwc_min_f32(%input : tensor<1x16x1xf32>, %shape: tensor<2xf32>, %output: tensor<1x4x1xf32>) -> tensor<1x4x1xf32> {
  %0 = linalg.pooling_nwc_min {dilations = dense<[2]> : tensor<1xi64>, strides = dense<[4]> : tensor<1xi64>}
    ins(%input, %shape : tensor<1x16x1xf32>, tensor<2xf32>) outs(%output : tensor<1x4x1xf32>) -> tensor<1x4x1xf32>
  return %0: tensor<1x4x1xf32>
}