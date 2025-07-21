module {
  func.func @main(%arg0: tensor<2x4xf32>, %arg1: tensor<4xf32>, %axis: i32) -> tensor<2x4xf32> {
    %0 = "tosa.reverse"(%arg0) {axis = 1 : i32} : (tensor<2x4xf32>) -> tensor<2x4xf32>
    %1 = "tosa.maximum"(%arg0, %arg0) : (tensor<2x4xf32>, tensor<2x4xf32>) -> tensor<2x4xf32>
    return %0 : tensor<2x4xf32>
  }
}