module {
  func.func @main(%input1: tensor<4xf32>) -> (tensor<4xf32>) {
    %0 = "tosa.reciprocal"(%input1) : (tensor<4xf32>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
  }
}