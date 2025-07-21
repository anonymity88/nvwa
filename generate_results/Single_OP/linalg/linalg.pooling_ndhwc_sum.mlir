func.func @pooling_ndhwc_sum_tensor(%input: tensor<1x4x4x4x1xf32>) -> tensor<1x2x2x2x1xf32> {
  %fake = tensor.empty() : tensor<3x3x3xf32>
  %init = tensor.empty() : tensor<1x2x2x2x1xf32>
  %cst = arith.constant 0.000000e+00 : f32
  %fill = linalg.fill ins(%cst : f32) outs(%init : tensor<1x2x2x2x1xf32>) -> tensor<1x2x2x2x1xf32>
  %res = linalg.pooling_ndhwc_sum {dilations = dense<1> : tensor<3xi64>, strides = dense<1> : tensor<3xi64>}
    ins(%input, %fake: tensor<1x4x4x4x1xf32>, tensor<3x3x3xf32>)
    outs(%fill: tensor<1x2x2x2x1xf32>) -> tensor<1x2x2x2x1xf32>
  return %res : tensor<1x2x2x2x1xf32>
}