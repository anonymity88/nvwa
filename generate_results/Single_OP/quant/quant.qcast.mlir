module {
  // Define a function that uses the quant.qcast operation
  func.func @main(%input: tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>> {
    // Use the quant.qcast operation to quantize the input tensor
    %result = quant.qcast %input : tensor<4xf32> to tensor<4x!quant.uniform<i8:f32, 2.0>>
    // Return the result from the function
    return %result : tensor<4x!quant.uniform<i8:f32, 2.0>>
  }
}