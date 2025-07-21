module {
  func.func @main(%arg0: tensor<4xi32>, %arg1: tensor<4xi32>) -> (tensor<4xi1>) {
    %0 = "tosa.greater_equal"(%arg0, %arg1) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
    return %0 : tensor<4xi1>
  }
}