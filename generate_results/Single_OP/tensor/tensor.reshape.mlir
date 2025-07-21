module {
  func.func @main(%src: tensor<4x1xf32>, %shape: tensor<2xi32>) -> tensor<2x2xf32> {
    %dst = tensor.reshape %src(%shape) : (tensor<4x1xf32>, tensor<2xi32>) -> tensor<2x2xf32>
    return %dst : tensor<2x2xf32>
  }
}