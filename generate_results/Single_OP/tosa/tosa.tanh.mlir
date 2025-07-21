module {
  func.func @main(%input: tensor<4xi32>) -> (tensor<4xi32>) {
    %0 = "tosa.tanh"(%input) : (tensor<4xi32>) -> tensor<4xi32>
    return %0 : tensor<4xi32>
  }
}