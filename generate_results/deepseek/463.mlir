!qalias = !quant.uniform<i8:f32, 2.0>

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
  
  func.func @dcast_ranked(%arg0: tensor<2x?x4x!qalias>) -> tensor<2x?x4xf32> {
    %0 = quant.dcast %arg0 : tensor<2x?x4x!qalias> to tensor<2x?x4xf32>
    return %0 : tensor<2x?x4xf32>
  }
  
  func.func @avg_pool2d_with_unsupported_quant_type(%arg0: tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>) -> tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>> {
    %0 = "tosa.avg_pool2d"(%arg0) {acc_type = i32, kernel = array<i64: 2, 2>, pad = array<i64: 0, 1, 0, 1>, stride = array<i64: 1, 1>} : (tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>) -> tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>
    return %0 : tensor<1x7x7x9x!quant.uniform<i8:f32, 0.01>>
  }
  
  func.func @main(%input: tensor<4xf32>) -> tensor<4xi8> {
    %quantized = call @quant_casts(%input) : (tensor<4xf32>) -> tensor<4x!quant.uniform<i8:f32, 2.0>>
    %final_result = call @scalar_cast(%quantized) : (tensor<4x!quant.uniform<i8:f32, 2.0>>) -> tensor<4xi8>
    
    // Demonstrate calling other functions
    %c2 = arith.constant 2 : index
    %c4 = arith.constant 4 : index
    %dynamic_tensor = tensor.empty(%c2) : tensor<2x?x4x!qalias>
    %dcast_result = call @dcast_ranked(%dynamic_tensor) : (tensor<2x?x4x!qalias>) -> tensor<2x?x4xf32>
    
    return %final_result : tensor<4xi8>
  }
}