module {
  func.func @main(%input: tensor<4xf32>) -> (tensor<4xf32>) {
    %0 = "tosa.exp"(%input) : (tensor<4xf32>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
  }
}