module {
  func.func @main(%arg0: tensor<4xi16>, %arg1: tensor<4xi16>) -> tensor<4xi32> {
    %0 = "tosa.mul"(%arg0, %arg1) {shift = 0 : i8} : (tensor<4xi16>, tensor<4xi16>) -> tensor<4xi32>
    return %0 : tensor<4xi32>
  }
}