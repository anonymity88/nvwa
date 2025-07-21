module {
  func.func @main(%input1: tensor<4xi32>) -> (tensor<4xi32>) {
    %output = "tosa.clz"(%input1) : (tensor<4xi32>) -> tensor<4xi32>
    return %output : tensor<4xi32>
  }
}