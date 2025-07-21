module {
  func.func @main(%a: tensor<1x4x4xf32>, %b: tensor<1x4x4xf32>) -> (tensor<1x4x4xf32>) {
    %c = "tosa.matmul"(%a, %b) : (tensor<1x4x4xf32>, tensor<1x4x4xf32>) -> tensor<1x4x4xf32>
    return %c : tensor<1x4x4xf32>
  }
}