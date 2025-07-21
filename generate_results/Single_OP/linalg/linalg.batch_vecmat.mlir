module {
  func.func @main(%batch: tensor<5x3xf32>, %matrix: tensor<5x3x6xf32>, %output: tensor<5x6xf32>) -> tensor<5x6xf32> {
    %result = linalg.batch_vecmat
              ins(%batch, %matrix : tensor<5x3xf32>, tensor<5x3x6xf32>)
              outs(%output : tensor<5x6xf32>) -> tensor<5x6xf32>

    return %result : tensor<5x6xf32>
  }
}