module {
  func.func @main(%input1: tensor<4xf32>, %input2: tensor<4xf32>) -> tensor<4xf32> {
    %0 = "tosa.minimum"(%input1, %input2) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
  }
}