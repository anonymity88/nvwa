module {
  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    return %0, %1 : i32, f32
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

  func.func @conv2d_4x4_3x3(%arg0: tensor<2x6x6x5xf32>, %arg1: tensor<2x3x3x5xf32>, %arg2: tensor<1xf32>, %out: tensor<2x4x4x2xf32>) -> tensor<2x4x4x2xf32> {
    %0 = linalg.conv_2d_nhwc_fhwc {dilations = dense<1> : tensor<2xi64>, strides = dense<1> : tensor<2xi64>} ins(%arg0, %arg1 : tensor<2x6x6x5xf32>, tensor<2x3x3x5xf32>) outs(%out : tensor<2x4x4x2xf32>) -> tensor<2x4x4x2xf32>
    return %0 : tensor<2x4x4x2xf32>
  }

  func.func @main() {
    // Process scalar data
    %const_i32 = arith.constant 5 : i32
    %const_f32 = arith.constant 2.5 : f32
    %result0, %result1 = call @process_data(%const_i32, %const_f32) : (i32, f32) -> (i32, f32)

    // Add scalar values
    %add_arg0 = arith.constant 1.0 : f32
    %add_arg1 = arith.constant 2.0 : f32
    %add_result = call @my_add(%add_arg0, %add_arg1) : (f32, f32) -> f32

    // Compute tensor result
    %input_tensor = arith.constant dense<1.0> : tensor<16xf32>
    %scale_factor = arith.constant 2.0 : f32
    %computed_result = call @compute_result(%input_tensor, %scale_factor) : (tensor<16xf32>, f32) -> tensor<16xf32>

    // Final scalar computations
    %final_i32 = arith.addi %result0, %const_i32 : i32
    %final_f32 = arith.addf %add_result, %result1 : f32

    // Setup and call conv2d operation
    %conv_input = arith.constant dense<1.0> : tensor<2x6x6x5xf32>
    %conv_filter = arith.constant dense<1.0> : tensor<2x3x3x5xf32>
    %conv_bias = arith.constant dense<0.0> : tensor<1xf32>
    %conv_out = arith.constant dense<0.0> : tensor<2x4x4x2xf32>
    %conv_result = call @conv2d_4x4_3x3(%conv_input, %conv_filter, %conv_bias, %conv_out) : (tensor<2x6x6x5xf32>, tensor<2x3x3x5xf32>, tensor<1xf32>, tensor<2x4x4x2xf32>) -> tensor<2x4x4x2xf32>

    return
  }
}