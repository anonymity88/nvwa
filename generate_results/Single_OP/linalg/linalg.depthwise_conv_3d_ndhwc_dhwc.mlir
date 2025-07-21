module {
  func.func @main(%input: tensor<1x4x4x4x3xf32>, 
                  %filter: tensor<3x3x3x3xf32>, 
                  %output: tensor<1x2x2x2x3xf32>) -> tensor<1x2x2x2x3xf32> {
    %0 = linalg.depthwise_conv_3d_ndhwc_dhwc 
         {strides = dense<[1, 1, 1]> : tensor<3xi64>, 
          dilations = dense<[1, 1, 1]> : tensor<3xi64>}
         ins(%input, %filter : tensor<1x4x4x4x3xf32>, tensor<3x3x3x3xf32>)
         outs(%output : tensor<1x2x2x2x3xf32>) -> tensor<1x2x2x2x3xf32>

    return %0 : tensor<1x2x2x2x3xf32>
  }
}