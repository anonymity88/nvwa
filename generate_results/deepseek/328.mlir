module {
  func.func @main(%input_pad: tensor<2x3xf32>, 
                  %padding: tensor<2x2xi32>, 
                  %pad_const: tensor<f32>,
                  %loop_arg: tensor<i32>,
                  %input_sin: tensor<?x?xf32>,
                  %cond_if: tensor<i1>,
                  %input1_cond: tensor<4xf32>,
                  %input2_cond: tensor<4xf32>,
                  %input_cos: tensor<4xf32>,
                  %arg0_max: tensor<4xf32>,
                  %arg1_max: tensor<4xf32>,
                  %scf_cond: i1,
                  %reduce_input: tensor<1x1x1x1x13x21x3xf32>) -> (tensor<6x7xf32>, 
                                    tensor<*xi32>,
                                    tensor<?x?xf32>,
                                    tensor<4xf32>,
                                    tensor<4xf32>,
                                    tensor<4xf32>,
                                    tensor<1x1x1x1x13x21x3xf32>) {
    // Pad operation
    %pad_result = "tosa.pad"(%input_pad, %padding, %pad_const) : (tensor<2x3xf32>, tensor<2x2xi32>, tensor<f32>) -> tensor<6x7xf32>
    
    // While loop operation
    %loop_init = tosa.add %loop_arg, %loop_arg : (tensor<i32>, tensor<i32>) -> tensor<*xi32>
    %loop_result = tosa.while_loop (%arg1 = %loop_init) : (tensor<*xi32>) -> tensor<*xi32> {
      %loop_const = "tosa.const"() <{value = dense<3> : tensor<i32>}> : () -> tensor<i32>
      %loop_cond = tosa.greater_equal %loop_const, %arg1 : (tensor<i32>, tensor<*xi32>) -> tensor<*xi1>
      tosa.yield %loop_cond : tensor<*xi1>
    } do {
    ^bb0(%arg1: tensor<*xi32>):
      %loop_body = tosa.add %arg1, %arg1 : (tensor<*xi32>, tensor<*xi32>) -> tensor<*xi32>
      tosa.yield %loop_body : tensor<*xi32>
    }
    
    // Sin operation
    %sin_result = "tosa.sin"(%input_sin) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Conditional operation
    %cond_result = "tosa.cond_if"(%cond_if) ({
      ^bb0():
        %add_result = "tosa.add"(%input1_cond, %input2_cond) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
        tosa.yield %add_result : tensor<4xf32>
      }, {
      ^bb0():
        %mul_result = "tosa.mul"(%input1_cond, %input2_cond) {shift = 0 : i8} : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
        tosa.yield %mul_result : tensor<4xf32>
      }) : (tensor<i1>) -> tensor<4xf32>
    
    // Cos operation
    %cos_result = "tosa.cos"(%input_cos) : (tensor<4xf32>) -> tensor<4xf32>
    
    // Maximum and select operations
    %max_result = "tosa.maximum"(%arg0_max, %arg1_max) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    %c0 = arith.constant dense<0> : tensor<4xi1>
    %select_result = "tosa.select"(%c0, %arg0_max, %max_result) : (tensor<4xi1>, tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    
    // SCF if operation
    %scf_result = scf.if %scf_cond -> tensor<4xf32> {
      %true_val = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32>
      scf.yield %true_val : tensor<4xf32>
    } else {
      %false_val = arith.constant dense<[5.0, 6.0, 7.0, 8.0]> : tensor<4xf32>
      scf.yield %false_val : tensor<4xf32>
    }
    
    // Call reduce_max function
    %reduce_result = call @test_reduce_max(%reduce_input) : (tensor<1x1x1x1x13x21x3xf32>) -> tensor<1x1x1x1x13x21x3xf32>
    
    return %pad_result, %loop_result, %sin_result, %cond_result, %cos_result, %scf_result, %reduce_result : 
           tensor<6x7xf32>, tensor<*xi32>, tensor<?x?xf32>, tensor<4xf32>, tensor<4xf32>, tensor<4xf32>, tensor<1x1x1x1x13x21x3xf32>
  }
  
  func.func @test_reduce_max(%arg0: tensor<1x1x1x1x13x21x3xf32>) -> tensor<1x1x1x1x13x21x3xf32> {
    %0 = "tosa.reduce_max"(%arg0) {axis = 0 : i32} : (tensor<1x1x1x1x13x21x3xf32>) -> tensor<1x1x1x1x13x21x3xf32>
    return %0 : tensor<1x1x1x1x13x21x3xf32>
  }
}