module {
  func.func @main(%lhs: tensor<2x3x4xf32>, %rhs: tensor<2x4x5xf32>, %output: tensor<3x5xf32>) -> tensor<3x5xf32> {
    %result = linalg.batch_reduce_matmul
         ins(%lhs, %rhs : tensor<2x3x4xf32>, tensor<2x4x5xf32>) 
         outs(%output : tensor<3x5xf32>) -> tensor<3x5xf32>

    return %result : tensor<3x5xf32>
  }
}