module {
  func.func @main(%input1_concat: tensor<4x2xi32>, 
                  %input2_concat: tensor<2x2xi32>,
                  %input_reciprocal: tensor<4xf32>,
                  %arg0_ge: tensor<4xi32>,
                  %arg1_ge: tensor<4xi32>,
                  %input_conv3d: tensor<1x49x48x47x27xf32>,
                  %weights_conv3d: tensor<28x3x4x5x27xf32>,
                  %bias_conv3d: tensor<28xf32>,
                  %rfft_input: tensor<13x8x16xf32>) -> (tensor<6x2xi32>, 
                                                       tensor<4xf32>, 
                                                       tensor<4xi1>,
                                                       tensor<1x47x45x43x28xf32>,
                                                       tensor<1x3xi32>,
                                                       tensor<13x8x9xf32>,
                                                       tensor<13x8x9xf32>) {
    // Concat operation
    %concat_result = "tosa.concat"(%input1_concat, %input2_concat) {axis = 0 : i32} : (tensor<4x2xi32>, tensor<2x2xi32>) -> tensor<6x2xi32>
    
    // Custom operation
    "tosa.custom"() {domain_name = "custom_op", operator_name = "my_custom_op", implementation_attrs = ""} : () -> ()
    
    // Reduce product operation
    %input_tensor = "tosa.const"() {value = dense<[[1, 2, 3], [4, 5, 6]]> : tensor<2x3xi32>} : () -> tensor<2x3xi32>
    %reduce_prod_result = tosa.reduce_prod %input_tensor {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
    
    // Conv3D operation
    %conv3d_result = tosa.conv3d %input_conv3d, %weights_conv3d, %bias_conv3d {pad = array<i64: 0, 0, 0, 0, 0, 0>, stride = array<i64: 1, 1, 1>, dilation = array<i64: 1, 1, 1>} : (tensor<1x49x48x47x27xf32>, tensor<28x3x4x5x27xf32>, tensor<28xf32>) -> tensor<1x47x45x43x28xf32>
    
    // Reciprocal operation
    %reciprocal_result = "tosa.reciprocal"(%input_reciprocal) : (tensor<4xf32>) -> tensor<4xf32>
    
    // Greater equal operation
    %ge_result = "tosa.greater_equal"(%arg0_ge, %arg1_ge) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
    
    // Call RFFT2D function
    %rfft_real, %rfft_imag = call @test_rfft2d(%rfft_input) : (tensor<13x8x16xf32>) -> (tensor<13x8x9xf32>, tensor<13x8x9xf32>)
    
    return %concat_result, %reciprocal_result, %ge_result, %conv3d_result, %reduce_prod_result, %rfft_real, %rfft_imag : 
           tensor<6x2xi32>, tensor<4xf32>, tensor<4xi1>, tensor<1x47x45x43x28xf32>, tensor<1x3xi32>, tensor<13x8x9xf32>, tensor<13x8x9xf32>
  }
  
  func.func @test_rfft2d(%arg0: tensor<13x8x16xf32>) -> (tensor<13x8x9xf32>, tensor<13x8x9xf32>) {
    %0, %1 = tosa.rfft2d %arg0 : (tensor<13x8x16xf32>) -> (tensor<13x8x9xf32>, tensor<13x8x9xf32>)
    return %0, %1 : tensor<13x8x9xf32>, tensor<13x8x9xf32>
  }
}