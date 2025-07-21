func.func @pooling_ncw_max_tensor(%input: tensor<1x1x4xf32>) -> tensor<1x1x2xf32> {
  %fake = tensor.empty() : tensor<3xf32>
  %init = tensor.empty() : tensor<1x1x2xf32>
  %cst = arith.constant 0.000000e+00 : f32
  %fill = linalg.fill ins(%cst : f32) outs(%init : tensor<1x1x2xf32>) -> tensor<1x1x2xf32>
  %res = linalg.pooling_ncw_max {dilations = dense<1> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>}
    ins(%input, %fake: tensor<1x1x4xf32>, tensor<3xf32>)
    outs(%fill: tensor<1x1x2xf32>) -> tensor<1x1x2xf32>
  return %res : tensor<1x1x2xf32>
}