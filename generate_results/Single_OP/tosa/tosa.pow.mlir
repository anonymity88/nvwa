module {
  func.func @main(%input1: tensor<4xf32>, %input2: tensor<4xf32>) -> (tensor<4xf32>) {
    %z = "tosa.pow"(%input1, %input2) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    return %z : tensor<4xf32>
  }
}