module {
  func.func @main(%lhs: tensor<4x5x2x3xf32>, %rhs: tensor<4x5x2x3xf32>, %output: tensor<4x4x2x2xf32>) -> tensor<4x4x2x2xf32> {
    %0 = linalg.mmt4d
         ins(%lhs, %rhs : tensor<4x5x2x3xf32>, tensor<4x5x2x3xf32>)
         outs(%output : tensor<4x4x2x2xf32>) -> tensor<4x4x2x2xf32>

    return %0 : tensor<4x4x2x2xf32>
  }
}