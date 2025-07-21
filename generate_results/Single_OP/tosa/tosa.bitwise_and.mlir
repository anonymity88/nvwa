module {
  func.func @main(%input1: tensor<4xi32>, %input2: tensor<4xi32>) -> (tensor<4xi32>) {
    %output = "tosa.bitwise_and"(%input1, %input2) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi32>
    return %output : tensor<4xi32>
  }
}