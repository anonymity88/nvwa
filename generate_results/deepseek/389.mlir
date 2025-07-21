!qalias = !quant.uniform<i8:f32:2, {2.0:10, 3.0:20, 4.0:30}>

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

  func.func @qcast_per_channel_unranked(%arg0: tensor<*xf32>) -> tensor<*x!qalias> {
    %0 = quant.qcast %arg0 : tensor<*xf32> to tensor<*x!qalias>
    return %0 : tensor<*x!qalias>
  }

  func.func @main(%input: tensor<4xf32>) -> (tensor<4x!quant.uniform<i8:f32, 2.0>>, tensor<4xf32>, tensor<4xi8>) {
    %quantized = call @quant_casts(%input) : (tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>>
    %dequantized = call @reverse_quant_casts(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32>
    %scalar = call @scalar_cast(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>
    
    // Demonstrate calling the unranked function with a cast
    %unranked_input = tensor.cast %input : tensor<4xf32> to tensor<*xf32>
    %unranked_result = call @qcast_per_channel_unranked(%unranked_input) : (tensor<*xf32>) -> tensor<*x!qalias>
    
    return %quantized, %dequantized, %scalar : tensor<4x!quant.uniform<i8:f32, 2.0>>, tensor<4xf32>, tensor<4xi8>
  }
}