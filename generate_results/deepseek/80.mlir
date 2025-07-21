module {
  func.func private @external_compute(i32, f32) -> f32
  func.func private @log_message()

  func.func @double(%x: i32) -> i32 {
    %0 = arith.addi %x, %x : i32
    return %0 : i32
  }

  func.func @compute_and_log(%value: i32 {dialectName.argAttribute = "input"}, %scale: f32) -> (f32 {dialectName.resAttribute = "output"}) {
    %1 = arith.mulf %scale, %scale : f32
    %2 = arith.sitofp %value : i32 to f32
    %3 = arith.mulf %2, %1 : f32
    %4 = func.call @external_compute(%value, %3) : (i32, f32) -> f32
    func.call @log_message() : () -> ()
    return %4 : f32
  }

  func.func @compute_result(%arg0: tensor<16xf32>, %arg1: f32) -> tensor<16xf32> {
    %cst_tensor = tensor.splat %arg1 : tensor<16xf32>
    %1 = arith.mulf %arg0, %cst_tensor : tensor<16xf32>
    return %1 : tensor<16xf32>
  }

  func.func @add_tensors(%arg0: tensor<16xf32>, %arg1: tensor<16xf32>) -> tensor<16xf32> {
    %result = arith.addf %arg0, %arg1 : tensor<16xf32>
    return %result : tensor<16xf32>
  }

  func.func @main() {
    // Compute and log operations
    %arg_i32 = arith.constant 10 : i32
    %arg_f32 = arith.constant 3.5 : f32
    %compute_log_result = func.call @compute_and_log(%arg_i32, %arg_f32) : (i32, f32) -> f32

    // Double operation
    %doubled_value = func.call @double(%arg_i32) : (i32) -> i32

    // Tensor computations
    %func_handle_compute = func.constant @compute_result : (tensor<16xf32>, f32) -> tensor<16xf32>
    %input_tensor = arith.constant dense<1.0> : tensor<16xf32>
    %scale_factor = arith.constant 2.0 : f32
    %computed_result = func.call_indirect %func_handle_compute(%input_tensor, %scale_factor) 
                        : (tensor<16xf32>, f32) -> tensor<16xf32>

    // Tensor addition
    %add_func = func.constant @add_tensors : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>
    %tensor_a = arith.constant dense<1.0> : tensor<16xf32>
    %tensor_b = arith.constant dense<2.0> : tensor<16xf32>
    %tensor_sum = func.call_indirect %add_func(%tensor_a, %tensor_b) 
                   : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>

    func.return
  }
}