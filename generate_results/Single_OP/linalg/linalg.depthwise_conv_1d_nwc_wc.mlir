module {
  func.func @main(%input: tensor<1x11x3xf32>, %filter: tensor<3x3xf32>, %output: tensor<1x9x3xf32>) -> tensor<1x9x3xf32> {
    %0 = linalg.depthwise_conv_1d_nwc_wc 
         {strides = dense<[1]> : tensor<1xi64>, dilations = dense<[1]> : tensor<1xi64>} 
         ins(%input, %filter : tensor<1x11x3xf32>, tensor<3x3xf32>) 
         outs(%output : tensor<1x9x3xf32>) -> tensor<1x9x3xf32>
    
    return %0 : tensor<1x9x3xf32>
  }
}