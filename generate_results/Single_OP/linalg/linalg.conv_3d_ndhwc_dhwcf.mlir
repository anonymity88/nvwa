module {
  func.func @main(%input: tensor<1x16x16x16x3xf32>, 
                  %filter: tensor<3x3x3x3x5xf32>, 
                  %output: tensor<1x14x14x14x5xf32>) -> tensor<1x14x14x14x5xf32> {
    %0 = linalg.conv_3d_ndhwc_dhwcf 
         {strides = dense<[1, 1, 1]> : tensor<3xi64>, 
          dilations = dense<[1, 1, 1]> : tensor<3xi64>} 
         ins(%input, %filter : tensor<1x16x16x16x3xf32>, tensor<3x3x3x3x5xf32>) 
         outs(%output : tensor<1x14x14x14x5xf32>) -> tensor<1x14x14x14x5xf32>
    
    return %0 : tensor<1x14x14x14x5xf32>
  }
}