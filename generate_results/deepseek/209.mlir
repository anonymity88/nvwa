module {
  func.func @main(%input1_or: tensor<?x?xi1>, 
                  %input2_or: tensor<?x?xi1>,
                  %input_ceil: tensor<?x?xf32>,
                  %input1_shift: tensor<4xi32>,
                  %input2_shift: tensor<4xi32>,
                  %input_not: tensor<4xi1>,
                  %variable_input: tensor<2x4x8xi32>) -> (tensor<1x3xi1>,
                                                         tensor<?x?xi1>,
                                                         tensor<?x?xf32>,
                                                         tensor<4xi32>,
                                                         tensor<4xi1>,
                                                         tensor<2x4x8xi16>) {
    // Reduce all example
    %const = "tosa.const"() <{value = dense<[[true, false, true], [false, true, false]]> : tensor<2x3xi1>}> : () -> tensor<2x3xi1>
    %reduce_all_result = tosa.reduce_all %const {axis = 0 : i32} : (tensor<2x3xi1>) -> tensor<1x3xi1>

    // Logical OR operation
    %logical_or_result = "tosa.logical_or"(%input1_or, %input2_or) : (tensor<?x?xi1>, tensor<?x?xi1>) -> tensor<?x?xi1>

    // Ceil operation
    %ceil_result = "tosa.ceil"(%input_ceil) : (tensor<?x?xf32>) -> tensor<?x?xf32>

    // Logical left shift
    %shift_result = "tosa.logical_left_shift"(%input1_shift, %input2_shift) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi32>

    // Logical not operation
    %not_result = "tosa.logical_not"(%input_not) : (tensor<4xi1>) -> tensor<4xi1>

    // Variable operations
    tosa.variable @stored_var = dense<-1> : tensor<2x4x8xi32>
    %var_read_result = tosa.variable.read @stored_var : tensor<2x4x8xi16>

    return %reduce_all_result, %logical_or_result, %ceil_result, %shift_result, %not_result, %var_read_result : 
           tensor<1x3xi1>, tensor<?x?xi1>, tensor<?x?xf32>, tensor<4xi32>, tensor<4xi1>, tensor<2x4x8xi16>
  }
}