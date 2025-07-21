func.func @depthwise_conv_2d_nchw_chw_tensor(%input: tensor<1x96x113x113xf32>, %filter: tensor<96x3x3xf32>) -> tensor<1x96x56x56xf32> {
  %init = tensor.empty() : tensor<1x96x56x56xf32>
  %0 = linalg.depthwise_conv_2d_nchw_chw {dilations = dense<1> : vector<2xi64>, strides = dense<2> : vector<2xi64>}
         ins(%input, %filter: tensor<1x96x113x113xf32>, tensor<96x3x3xf32>)
         outs(%init: tensor<1x96x56x56xf32>) -> tensor<1x96x56x56xf32>
  return %0: tensor<1x96x56x56xf32>
}