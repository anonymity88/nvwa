!qalias = !quant.uniform<i8:f32, 2.0:10>

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

  func.func @qcast_per_channel_ranked_bounds(%arg0: tensor<4x2x5xf32>) -> tensor<4x2x5x!qalias> {
    %0 = quant.qcast %arg0 : tensor<4x2x5xf32> to tensor<4x2x5x!qalias>
    return %0 : tensor<4x2x5x!qalias>
  }

  func.func @qcast_per_layer_scalar(%arg0: f32) -> !qalias {
    %0 = quant.qcast %arg0 : f32 to !qalias
    return %0 : !qalias
  }

  func.func @main(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> (tensor<4xi8>, tensor<4x2x5x!qalias>) {
    // Demonstrate the full quantization cycle
    %dequantized = call @reverse_quant_casts(%input) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32>
    %scalar_result = call @scalar_cast(%input) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>

    // Create a ranked tensor for per-channel quantization
    %ranked_tensor = tensor.empty() : tensor<4x2x5xf32>
    %per_channel_quant = call @qcast_per_channel_ranked_bounds(%ranked_tensor) : (tensor<4x2x5xf32>) -> tensor<4x2x5x!qalias>

    // Demonstrate scalar quantization
    %c0 = arith.constant 0 : index
    %scalar_value = tensor.extract %dequantized[%c0] : tensor<4xf32>
    %scalar_quant = call @qcast_per_layer_scalar(%scalar_value) : (f32) -> !qalias

    return %scalar_result, %per_channel_quant : tensor<4xi8>, tensor<4x2x5x!qalias>
  }
}