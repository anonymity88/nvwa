module {
  func.func @main(
    %input: tensor<1x28x28x3xf32>, 
    %kernel: tensor<3x3xf32>,
    %output: tensor<1x26x26x3xf32>
  ) -> tensor<1x26x26x3xf32> {
    %0 = linalg.pooling_nhwc_sum 
         {strides = dense<[1, 1]> : tensor<2xi64>, 
          dilations = dense<[1, 1]> : tensor<2xi64>}
         ins(%input, %kernel : tensor<1x28x28x3xf32>, tensor<3x3xf32>)
         outs(%output : tensor<1x26x26x3xf32>) -> tensor<1x26x26x3xf32>
    
    return %0 : tensor<1x26x26x3xf32>
  }
}