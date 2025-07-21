module {
  func.func @main(
    %input: tensor<1x10x3xf32>, 
    %kernel_size: tensor<3xf32>,
    %output: tensor<1x8x3xf32>
  ) -> tensor<1x8x3xf32> {
    %0 = linalg.pooling_nwc_max 
         {strides = dense<[1]> : tensor<1xi64>, 
          dilations = dense<[1]> : tensor<1xi64>}
         ins(%input, %kernel_size : tensor<1x10x3xf32>, tensor<3xf32>)
         outs(%output : tensor<1x8x3xf32>) -> tensor<1x8x3xf32>

    return %0 : tensor<1x8x3xf32>
  }
}