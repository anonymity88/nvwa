module {
  func.func @main(%input: tensor<4x3xi32>) -> tensor<4x1xi32> {
    %0 = "tosa.reduce_min"(%input) {axis = 1 : i32} : (tensor<4x3xi32>) -> tensor<4x1xi32>
    return %0 : tensor<4x1xi32>
  }
}