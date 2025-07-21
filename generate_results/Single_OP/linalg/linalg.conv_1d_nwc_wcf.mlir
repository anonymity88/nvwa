module {
  func.func @main(
    %input: tensor<1x10x3xf32>, 
    %filter: tensor<3x3x5xf32>, 
    %output: tensor<1x8x5xf32>
  ) -> tensor<1x8x5xf32> {
    %result = linalg.conv_1d_nwc_wcf 
         {strides = dense<[1]> : tensor<1xi64>, 
          dilations = dense<[1]> : tensor<1xi64>}
         ins(%input, %filter : tensor<1x10x3xf32>, tensor<3x3x5xf32>)
         outs(%output : tensor<1x8x5xf32>) -> tensor<1x8x5xf32>

    return %result : tensor<1x8x5xf32>
  }
}