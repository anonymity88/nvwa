module {
  func.func @main(%values: tensor<4x8x16xf32>, %indices: tensor<2x3xi32>) -> (tensor<2x3x16xf32>) {
    %output = "tosa.gather"(%values, %indices) : (tensor<4x8x16xf32>, tensor<2x3xi32>) -> tensor<2x3x16xf32>
    return %output : tensor<2x3x16xf32>
  }
}