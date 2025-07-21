module {
  func.func @main(%a: tensor<2x3x4xf32>, %b: tensor<2x4x5xf32>, %output: tensor<2x3x5xf32>) -> tensor<2x3x5xf32> {
    %0 = linalg.batch_matmul ins(%a, %b : tensor<2x3x4xf32>, tensor<2x4x5xf32>) 
                              outs(%output : tensor<2x3x5xf32>) -> tensor<2x3x5xf32>

    return %0 : tensor<2x3x5xf32>
  }
}