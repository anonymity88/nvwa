module {
  func.func @main(%arg0: tensor<3x4xf32>) -> tensor<3xi32> {
    %0 = tosa.argmax %arg0 {axis = 1 : i32} : (tensor<3x4xf32>) -> tensor<3xi32>
    return %0 : tensor<3xi32>
  }
}