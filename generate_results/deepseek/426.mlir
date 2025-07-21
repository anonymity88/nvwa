!qalias = !quant.uniform<u8<2:10>:f32, 2.0>

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
  
  func.func @qcast_per_layer_scalar_unsigned_bounds(%arg0: f32) -> !qalias {
    %0 = quant.qcast %arg0 : f32 to !qalias
    return %0 : !qalias
  }
  
  func.func @main(%input: tensor<4xf32>) -> (tensor<4xi8>, tensor<4xf32>) {
    %quantized = call @quant_casts(%input) : (tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>>
    %scalar_result = call @scalar_cast(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>
    %dequantized = call @reverse_quant_casts(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32>
    
    // Demonstrate calling the scalar unsigned bounds function
    %c0 = arith.constant 0 : index
    %scalar_value = tensor.extract %input[%c0] : tensor<4xf32>
    %unsigned_scalar = call @qcast_per_layer_scalar_unsigned_bounds(%scalar_value) : (f32) -> !qalias
    
    return %scalar_result, %dequantized : tensor<4xi8>, tensor<4xf32>
  }
}