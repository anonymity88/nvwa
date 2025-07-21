module {
  func.func @main(%input: tensor<4xf32>) -> (tensor<4xf32>) {
    %output = "tosa.cos"(%input) : (tensor<4xf32>) -> tensor<4xf32>
    return %output : tensor<4xf32>
  }
}