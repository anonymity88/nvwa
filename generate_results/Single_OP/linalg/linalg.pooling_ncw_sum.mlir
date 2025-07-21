module {
  func.func @main(
    %input: tensor<1x3x10xf32>, 
    %kernel: tensor<3xf32>, 
    %output: tensor<1x3x8xf32>
  ) -> tensor<1x3x8xf32> {
    %result = linalg.pooling_ncw_sum 
              {strides = dense<[1]> : tensor<1xi64>, 
               dilations = dense<[1]> : tensor<1xi64>}
              ins(%input, %kernel : tensor<1x3x10xf32>, tensor<3xf32>) 
              outs(%output : tensor<1x3x8xf32>) -> tensor<1x3x8xf32>

    return %result : tensor<1x3x8xf32>
  }
}