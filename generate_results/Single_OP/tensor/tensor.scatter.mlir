module {
  func.func @main(%source: tensor<1x2xf32>, %dest: tensor<4x4x4xf32>, %indices: tensor<1x2x3xi32>) -> tensor<4x4x4xf32> {
    %out = tensor.scatter %source into %dest[%indices] scatter_dims([0, 1, 2]) unique : 
      (tensor<1x2xf32>, tensor<4x4x4xf32>, tensor<1x2x3xi32>) -> tensor<4x4x4xf32>
    return %out : tensor<4x4x4xf32>
  }
}