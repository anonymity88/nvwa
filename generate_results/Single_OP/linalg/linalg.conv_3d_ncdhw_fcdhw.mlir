module {
  func.func @main(
    %input: tensor<1x3x32x32x32xf32>, 
    %filter: tensor<3x3x3x3x3xf32>, 
    %bias: tensor<3xf32>, 
    %output: tensor<1x3x30x30x30xf32>
  ) -> tensor<1x3x30x30x30xf32> {
    %0 = linalg.conv_3d_ncdhw_fcdhw 
         {strides = dense<[1, 1, 1]> : tensor<3xi64>, 
          dilations = dense<[1, 1, 1]> : tensor<3xi64>}
         ins(%input, %filter : tensor<1x3x32x32x32xf32>, tensor<3x3x3x3x3xf32>)
         outs(%output : tensor<1x3x30x30x30xf32>) -> tensor<1x3x30x30x30xf32>
          
    return %0 : tensor<1x3x30x30x30xf32>
  }
}