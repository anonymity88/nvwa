func.func @pooling_ndhwc_max(%input: memref<1x4x4x4x1xf32>, %fake: memref<3x3x3xf32>, %output: memref<1x2x2x2x1xf32>) {
  linalg.pooling_ndhwc_max {dilations = dense<1> : tensor<3xi64>, strides = dense<1> : tensor<3xi64>}
    ins(%input, %fake: memref<1x4x4x4x1xf32>, memref<3x3x3xf32>)
    outs(%output: memref<1x2x2x2x1xf32>)
  return
}