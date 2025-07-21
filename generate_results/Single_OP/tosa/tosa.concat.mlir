module {
  func.func @main(%input1: tensor<4x2xi32>, %input2: tensor<2x2xi32>) -> (tensor<6x2xi32>) {
    %0 = "tosa.concat"(%input1, %input2) {axis = 0 : i32} : (tensor<4x2xi32>, tensor<2x2xi32>) -> tensor<6x2xi32>
    return %0 : tensor<6x2xi32>
  }
}