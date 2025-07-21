module {
  // Define a function that uses the quant.dcast operation
  func.func @main(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32> {
    // Use the quant.dcast operation to dequantize the input tensor
    %result = quant.dcast %input : tensor<4x!quant.uniform<i8:f32, 2.0>> to tensor<4xf32>
    // Return the result from the function
    return %result : tensor<4xf32>
  }
}