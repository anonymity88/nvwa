module {
  func.func @main(%value: f32, %output: tensor<3x3xf32>) -> tensor<3x3xf32> {
    %0 = linalg.fill ins(%value : f32) outs(%output : tensor<3x3xf32>) -> tensor<3x3xf32>
    
    return %0 : tensor<3x3xf32>
  }
}