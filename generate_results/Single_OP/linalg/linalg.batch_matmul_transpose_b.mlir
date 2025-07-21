module {
  func.func @main(%lhs: tensor<2x3x4xf32>, %rhs: tensor<2x5x4xf32>, %output: tensor<2x3x5xf32>) -> tensor<2x3x5xf32> {
    %result = linalg.batch_matmul_transpose_b 
         ins(%lhs, %rhs : tensor<2x3x4xf32>, tensor<2x5x4xf32>) 
         outs(%output : tensor<2x3x5xf32>) -> tensor<2x3x5xf32>

    return %result : tensor<2x3x5xf32>
  }
}