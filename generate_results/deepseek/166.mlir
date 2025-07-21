module {
  func.func @quant_casts(%input: tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>> {
    %result = quant.qcast %input : tensor<4xf32> to tensor<4x!quant.uniform<i8:f32, 2.0>>
    return %result : tensor<4x!quant.uniform<i8:f32, 2.0>>
  }
  
  func.func @reverse_quant_casts(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32> {
    %result = quant.dcast %input : tensor<4x!quant.uniform<i8:f32, 2.0>> to tensor<4xf32>
    return %result : tensor<4xf32>
  }
  
  func.func @scalar_cast(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8> {
    %result = quant.scast %input : tensor<4x!quant.uniform<i8:f32, 2.0>> to tensor<4xi8>
    return %result : tensor<4xi8>
  }
  
  func.func @main(%input: tensor<4xf32>) -> (tensor<4xi8>, tensor<4xf32>) {
    // First path: quantize then cast to scalar
    %quantized = call @quant_casts(%input) : (tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>>
    %scalar_result = call @scalar_cast(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>
    
    // Second path: quantize then dequantize
    %dequantized = call @reverse_quant_casts(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32>
    
    return %scalar_result, %dequantized : tensor<4xi8>, tensor<4xf32>
  }
}