module {
  func.func @main(%arg0: tensor<4xi32>, %arg1: tensor<4xi32>) -> tensor<4xi32> {
    %0 = "tosa.arithmetic_right_shift"(%arg0, %arg1) {round = true} : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi32>
    return %0 : tensor<4xi32>
  }
}