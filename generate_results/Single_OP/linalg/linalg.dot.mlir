module {
  func.func @main(%vector_a: tensor<4xf32>, %vector_b: tensor<4xf32>, %output: tensor<f32>) -> tensor<f32> {
    %0 = linalg.dot ins(%vector_a, %vector_b : tensor<4xf32>, tensor<4xf32>) outs(%output : tensor<f32>) -> tensor<f32>

    return %0 : tensor<f32>
  }
}