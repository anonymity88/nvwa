module {
  func.func @main(%input: tensor<4x8x16xf32>) -> (tensor<4x8x9xf32>, tensor<4x8x9xf32>) {
    %0:2 = "tosa.rfft2d"(%input) : (tensor<4x8x16xf32>) -> (tensor<4x8x9xf32>, tensor<4x8x9xf32>)
    return %0#0, %0#1 : tensor<4x8x9xf32>, tensor<4x8x9xf32>
  }
}