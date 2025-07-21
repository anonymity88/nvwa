module {
  func.func @main(
    %input: tensor<1x2x3x32x32xf32>, 
    %filter: tensor<2x2x3x3x3xf32>, 
    %bias: tensor<2xf32>, 
    %output: tensor<1x2x2x30x30xf32>
  ) -> tensor<1x2x2x30x30xf32> {
    %0 = linalg.conv_2d_ngchw_gfchw 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>}
         ins(%input, %filter : tensor<1x2x3x32x32xf32>, tensor<2x2x3x3x3xf32>)
         outs(%output : tensor<1x2x2x30x30xf32>) -> tensor<1x2x2x30x30xf32> 
         
    return %0 : tensor<1x2x2x30x30xf32>
  }
}