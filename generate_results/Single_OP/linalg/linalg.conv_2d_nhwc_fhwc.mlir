module {
  func.func @main(
    %input: tensor<1x32x32x3xf32>, 
    %filter: tensor<3x3x3x3xf32>, 
    %bias: tensor<3xf32>, 
    %output: tensor<1x30x30x3xf32>
  ) -> tensor<1x30x30x3xf32> {
    %0 = linalg.conv_2d_nhwc_fhwc 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>}
         ins(%input, %filter : tensor<1x32x32x3xf32>, tensor<3x3x3x3xf32>)
         outs(%output : tensor<1x30x30x3xf32>) -> tensor<1x30x30x3xf32>
          
    return %0 : tensor<1x30x30x3xf32>
  }
}