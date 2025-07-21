module {
  func.func @main(
    %input: tensor<1x2x3x8x8xf32>,  // NGCHW format
    %filter: tensor<2x2x3x3x3xf32>, // FGCHW format
    %output: tensor<1x2x2x6x6xf32>  // NGKH'W' format, resulting after convolution
  ) -> tensor<1x2x2x6x6xf32> {
    %0 = linalg.conv_2d_ngchw_fgchw 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>}
         ins(%input, %filter : tensor<1x2x3x8x8xf32>, tensor<2x2x3x3x3xf32>)
         outs(%output : tensor<1x2x2x6x6xf32>) -> tensor<1x2x2x6x6xf32>
    
    return %0 : tensor<1x2x2x6x6xf32>
  }
}