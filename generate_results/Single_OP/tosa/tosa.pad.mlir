module {
  func.func @main(%input: tensor<2x3xf32>, %padding: tensor<2x2xi32>, %pad_const: tensor<f32>) -> tensor<6x7xf32> {
    %result = "tosa.pad"(%input, %padding, %pad_const) : (tensor<2x3xf32>, tensor<2x2xi32>, tensor<f32>) -> tensor<6x7xf32>
    return %result : tensor<6x7xf32>
  }
}