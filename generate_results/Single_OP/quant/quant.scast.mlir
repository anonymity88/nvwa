module {
  // Define a function that uses the quant.scast operation
  func.func @main(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8> {
    // Use the quant.scast operation to cast the quantized input tensor to signless integer storage type
    %result = quant.scast %input : tensor<4x!quant.uniform<i8:f32, 2.0>> to tensor<4xi8>
    // Return the result from the function
    return %result : tensor<4xi8>
  }
}