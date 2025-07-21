module {
  func.func @main(%values_in: tensor<3x4x5xf32>, %indices: tensor<2x3xi32>, %input: tensor<3x4x5xf32>) -> (tensor<3x4x5xf32>) {
    %values_out = "tosa.scatter"(%values_in, %indices, %input) : (tensor<3x4x5xf32>, tensor<2x3xi32>, tensor<3x4x5xf32>) -> tensor<3x4x5xf32>
    return %values_out : tensor<3x4x5xf32>
  }
}