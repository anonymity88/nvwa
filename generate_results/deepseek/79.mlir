module {
  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    func.return %0, %1 : i32, f32
  }

  func.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @compute_result(%arg0: tensor<16xf32>, %arg1: f32) -> tensor<16xf32> {
    %cst_tensor = tensor.splat %arg1 : tensor<16xf32>
    %1 = arith.mulf %arg0, %cst_tensor : tensor<16xf32>
    return %1 : tensor<16xf32>
  }

  func.func @main() {
    // Process data call
    %const_i32 = arith.constant 5 : i32
    %const_f32 = arith.constant 2.5 : f32
    %result0, %result1 = func.call @process_data(%const_i32, %const_f32) : (i32, f32) -> (i32, f32)

    // Simple add call
    %add_arg0 = arith.constant 1.0 : f32
    %add_arg1 = arith.constant 2.0 : f32
    %add_result = func.call @my_add(%add_arg0, %add_arg1) : (f32, f32) -> f32

    // Tensor computation
    %func_handle = func.constant @compute_result : (tensor<16xf32>, f32) -> tensor<16xf32>
    %input_tensor = arith.constant dense<1.0> : tensor<16xf32>
    %scale_factor = arith.constant 2.0 : f32
    %computed_result = func.call_indirect %func_handle(%input_tensor, %scale_factor) 
                        : (tensor<16xf32>, f32) -> tensor<16xf32>

    // Use some results to create data flow dependencies
    %final_i32 = arith.addi %result0, %const_i32 : i32
    %final_f32 = arith.addf %add_result, %result1 : f32

    func.return
  }
}