module {
  func.func @main(
    %input: tensor<1x64x64x3xf32>,
    %filter: tensor<5x5x3x8xf32>,
    %output: tensor<1x60x60x8xf32>
  ) -> tensor<1x60x60x8xf32> {
    %result = linalg.conv_2d_nhwc_hwcf 
        {strides = dense<[1, 1]> : tensor<2xi64>, 
         dilations = dense<[1, 1]> : tensor<2xi64>}
        ins(%input, %filter : tensor<1x64x64x3xf32>, tensor<5x5x3x8xf32>) 
        outs(%output : tensor<1x60x60x8xf32>)
        -> tensor<1x60x60x8xf32>
        
    return %result : tensor<1x60x60x8xf32>
  }
}