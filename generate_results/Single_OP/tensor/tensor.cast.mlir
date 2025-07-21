module {
  func.func @main(%input: tensor<*xf32>) -> tensor<4x?xf32> {
    // Perform a tensor cast from unknown rank to rank 2 with a known first dimension
    %casted_tensor = tensor.cast %input : tensor<*xf32> to tensor<4x?xf32>
    
    return %casted_tensor : tensor<4x?xf32>
  }
}