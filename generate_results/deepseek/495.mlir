!qalias = !quant.uniform<i8:f32, 2.0>
!qalias1 = !quant.uniform<u8:f32, 3.0:128>

module {
  func.func @quant_casts(%input: tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>> {
    %result = quant.qcast %input : tensor<4xf32> to tensor<4x!quant.uniform<i8:f32, 2.0>>
    return %result : tensor<4x!quant.uniform<i8:f32, 2.0>>
  }

  func.func @scalar_cast(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8> {
    %result = quant.scast %input : tensor<4x!quant.uniform<i8:f32, 2.0>> to tensor<4xi8>
    return %result : tensor<4xi8>
  }

  func.func @reverse_quant_casts(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32> {
    %result = quant.dcast %input : tensor<4x!quant.uniform<i8:f32, 2.0>> to tensor<4xf32>
    return %result : tensor<4xf32>
  }

  func.func @qcast_no_fold_type(%arg0: tensor<4x!qalias>) -> tensor<4x!qalias1> {
    %0 = quant.dcast %arg0 : tensor<4x!qalias> to tensor<4xf32>
    %1 = quant.qcast %0 : tensor<4xf32> to tensor<4x!qalias1>
    return %1 : tensor<4x!qalias1>
  }

  func.func @avg_pool2d_with_unsupported_quant_type(%arg0: tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>) -> tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>> {
    %0 = "tosa.avg_pool2d"(%arg0) {acc_type = i32, kernel = array<i64: 2, 2>, pad = array<i64: 0, 1, 0, 1>, stride = array<i64: 1, 1>} : (tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>) -> tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>
    return %0 : tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>
  }

  func.func @main(%input: tensor<4x!quant.uniform<i8:f32, 2.0>>) -> (tensor<4xi8>, tensor<4x!qalias1>) {
    // Demonstrate the full quantization cycle
    %dequantized = call @reverse_quant_casts(%input) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xf32>
    %scalar_result = call @scalar_cast(%input) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>

    // Create a tensor for type conversion demonstration
    %quant_tensor = tensor.empty() : tensor<4x!qalias>
    %converted_type = call @qcast_no_fold_type(%quant_tensor) : (tensor<4x!qalias>) -> tensor<4x!qalias1>

    // Demonstrate calling the avg_pool2d function
    %pool_input = tensor.empty() : tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>
    %pool_result = call @avg_pool2d_with_unsupported_quant_type(%pool_input) : (tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>) -> tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>

    return %scalar_result, %converted_type : tensor<4xi8>, tensor<4x!qalias1>
  }
}