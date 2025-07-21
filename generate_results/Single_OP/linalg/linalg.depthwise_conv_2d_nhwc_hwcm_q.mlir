func.func @depthwise_conv_q(%arg0: tensor<?x?x?x?xi8>, %arg1: tensor<?x?x?x1xi8>, %arg2: tensor<?x?x?x?x1xi32>, %arg3 : i32, %arg4 : i32) -> tensor<?x?x?x?x1xi32> {
  %0 = linalg.depthwise_conv_2d_nhwc_hwcm_q {_someattr, dilations = dense<1> : tensor<2xi64>, strides = dense<2> : tensor<2xi64>} ins(%arg0, %arg1, %arg3, %arg4 : tensor<?x?x?x?xi8>, tensor<?x?x?x1xi8>, i32, i32) outs(%arg2 : tensor<?x?x?x?x1xi32>) -> tensor<?x?x?x?x1xi32>
  return %0 : tensor<?x?x?x?x1xi32>
}