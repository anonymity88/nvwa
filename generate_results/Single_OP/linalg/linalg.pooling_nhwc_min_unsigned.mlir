func.func @generalize_pooling_nhwc_min_unsigned_i32(%input : tensor<1x4x16x1xi32>, %shape: tensor<2x2xi32>, %output: tensor<1x2x4x1xi32>) -> tensor<1x2x4x1xi32> {
  %0 = linalg.pooling_nhwc_min_unsigned {dilations = dense<[1, 2]> : tensor<2xi64>, strides = dense<[2, 4]> : tensor<2xi64>}
    ins(%input, %shape : tensor<1x4x16x1xi32>, tensor<2x2xi32>) outs(%output : tensor<1x2x4x1xi32>) -> tensor<1x2x4x1xi32>
  return %0: tensor<1x2x4x1xi32>
}