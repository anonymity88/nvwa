module {
  func.func @main(%input: tensor<28x28xf32>, %filter: tensor<3x3xf32>, %output: tensor<26x26xf32>) -> tensor<26x26xf32> {
    %result = linalg.conv_2d
         ins(%input, %filter : tensor<28x28xf32>, tensor<3x3xf32>)
         outs(%output : tensor<26x26xf32>) -> tensor<26x26xf32>

    return %result : tensor<26x26xf32>
  }
}