module {
  func.func @main(%input: tensor<1x4x4x4x3xf32>, 
                  %window: tensor<2x2x2xi32>,
                  %output: tensor<1x2x2x2x3xf32>) -> tensor<1x2x2x2x3xf32> {
    %0 = linalg.pooling_ndhwc_min 
         {strides = dense<[2, 2, 2]> : tensor<3xi64>, 
          dilations = dense<[1, 1, 1]> : tensor<3xi64>}
         ins(%input, %window : tensor<1x4x4x4x3xf32>, tensor<2x2x2xi32>) 
         outs(%output : tensor<1x2x2x2x3xf32>) -> tensor<1x2x2x2x3xf32>
    
    return %0 : tensor<1x2x2x2x3xf32>
  }
}