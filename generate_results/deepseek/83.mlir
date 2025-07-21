module {
  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    func.return %0, %1 : i32, f32
  }

  func.func @add_tensors(%arg0: tensor<16xf32>, %arg1: tensor<16xf32>) -> tensor<16xf32> {
    %result = arith.addf %arg0, %arg1 : tensor<16xf32>
    return %result : tensor<16xf32>
  }

  func.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @main() {
    // Process data operations
    %const_i32 = arith.constant 5 : i32
    %const_f32 = arith.constant 2.5 : f32
    %result0, %result1 = func.call @process_data(%const_i32, %const_f32) : (i32, f32) -> (i32, f32)

    // Scalar addition operations
    %scalar_a = arith.constant 1.0 : f32
    %scalar_b = arith.constant 2.0 : f32
    %scalar_result = func.call @my_add(%scalar_a, %scalar_b) : (f32, f32) -> f32

    // Tensor addition operations
    %tensor_a = arith.constant dense<1.0> : tensor<16xf32>
    %tensor_b = arith.constant dense<2.0> : tensor<16xf32>
    %tensor_func = func.constant @add_tensors : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>
    %tensor_result = func.call_indirect %tensor_func(%tensor_a, %tensor_b) 
                      : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>

    func.return
  }
}