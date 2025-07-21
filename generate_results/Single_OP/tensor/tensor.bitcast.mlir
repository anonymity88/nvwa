module {
  func.func @main(%src: tensor<4xui32>) -> tensor<4xi32> {
    // Performing a bitcast from a tensor of unsigned integers to signed integers
    %bitcasted_tensor = tensor.bitcast %src : tensor<4xui32> to tensor<4xi32>
    return %bitcasted_tensor : tensor<4xi32>
  }
}