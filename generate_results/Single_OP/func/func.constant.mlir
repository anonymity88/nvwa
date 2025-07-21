module {
  // Declare a function to be referenced by func.constant
  func.func @compute_result(%arg0: tensor<16xf32>, %arg1: f32) -> tensor<16xf32> {
    %cst_tensor = tensor.splat %arg1 : tensor<16xf32>
    %1 = arith.mulf %arg0, %cst_tensor : tensor<16xf32>
    return %1 : tensor<16xf32>
  }

  // Main function
  func.func @main() {
    // Using func.constant to reference the function @compute_result
    %func_handle = func.constant @compute_result : (tensor<16xf32>, f32) -> tensor<16xf32>

    // Define constant values for arguments
    %input_tensor = arith.constant dense<1.0> : tensor<16xf32>
    %scale_factor = arith.constant 2.0 : f32

    // Call the function using the reference from func.constant
    %computed_result = func.call_indirect %func_handle(%input_tensor, %scale_factor) 
                        : (tensor<16xf32>, f32) -> tensor<16xf32>

    // Return from main
    func.return
  }
}