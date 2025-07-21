module {
  func.func @main(%lhs: tensor<8x4x5x2x3xf32>, %rhs: tensor<8x4x5x2x3xf32>, %output: tensor<8x4x4x2x2xf32>) -> tensor<8x4x4x2x2xf32> {
    %result = linalg.batch_mmt4d
         ins(%lhs, %rhs : tensor<8x4x5x2x3xf32>, tensor<8x4x5x2x3xf32>)
         outs(%output : tensor<8x4x4x2x2xf32>) -> tensor<8x4x4x2x2xf32>

    return %result : tensor<8x4x4x2x2xf32>
  }
}