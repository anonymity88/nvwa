module {
  func.func @main(%input: tensor<4x4xf32>, %output: tensor<4x4xf32>) -> tensor<4x4xf32> {
    %0 = linalg.log ins(%input : tensor<4x4xf32>)
                   outs(%output : tensor<4x4xf32>) -> tensor<4x4xf32>

    return %0 : tensor<4x4xf32>
  }
}