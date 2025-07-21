!qalias = !quant.uniform<i8:f32, 1.0>
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

  func.func @dcast_scalar(%arg0: !qalias) {
    %0 = quant.dcast %arg0 : !qalias to f32
    return
  }

  func.func @main(%input: tensor<4xf32>) -> (tensor<4xf32>, tensor<4xi8>) {
    %quantized = call @quant_casts(%input) : (tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>>
    %dequantized = call @reverse_quant_casts(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32>
    %scalar = call @scalar_cast(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>
    return %dequantized, %scalar : tensor<4xf32>, tensor<4xi8>
  }
}