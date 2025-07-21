module {
  func.func @main(
    %input: tensor<16xf32>, 
    %kernel: tensor<3xf32>, 
    %output: tensor<14xf32>
  ) -> tensor<14xf32> {
    %0 = linalg.conv_1d 
         ins(%input, %kernel : tensor<16xf32>, tensor<3xf32>)
         outs(%output : tensor<14xf32>) -> tensor<14xf32>

    return %0 : tensor<14xf32>
  }
}