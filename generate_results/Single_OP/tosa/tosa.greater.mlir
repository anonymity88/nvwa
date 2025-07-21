module {
  func.func @main(%input1: tensor<4xi32>, %input2: tensor<4xi32>) -> (tensor<4xi1>) {
    %output = "tosa.greater"(%input1, %input2) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
    return %output : tensor<4xi1>
  }
}