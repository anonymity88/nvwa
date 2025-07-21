module {
  func.func @combined_main(
      %input1_concat: tensor<4x2xi32>,
      %input2_concat: tensor<2x2xi32>,
      %input_ceil: tensor<?x?xf32>,
      %arg0_scale: vector<4xi32>,
      %arg1_scale: vector<4xi32>,
      %arg2_scale: vector<4xi8>,
      %arg0_reverse: tensor<2x4xf32>,
      %arg1_reverse: tensor<4xf32>,
      %axis: i32,
      %input_reduce: tensor<4x3xi32>,
      %arg0_max: tensor<4xf32>,
      %arg1_max: tensor<4xf32>,
      %cond: i1
  ) -> (tensor<6x2xi32>, tensor<?x?xf32>, vector<4xi32>, tensor<2x4xf32>, tensor<4x1xi32>, tensor<4xf32>) {
    // Concat operation
    %concat_result = "tosa.concat"(%input1_concat, %input2_concat) {axis = 0 : i32} : (tensor<4x2xi32>, tensor<2x2xi32>) -> tensor<6x2xi32>
    
    // Ceil operation
    %ceil_result = "tosa.ceil"(%input_ceil) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Apply scale operation
    %scale_result = tosa.apply_scale %arg0_scale, %arg1_scale, %arg2_scale {double_round = true} : (vector<4xi32>, vector<4xi32>, vector<4xi8>) -> vector<4xi32>
    
    // Reverse operation
    %reverse_result = "tosa.reverse"(%arg0_reverse) {axis = 1 : i32} : (tensor<2x4xf32>) -> tensor<2x4xf32>
    %max_reverse_result = "tosa.maximum"(%arg0_reverse, %arg0_reverse) : (tensor<2x4xf32>, tensor<2x4xf32>) -> tensor<2x4xf32>
    
    // Reduce min operation
    %reduce_result = "tosa.reduce_min"(%input_reduce) {axis = 1 : i32} : (tensor<4x3xi32>) -> tensor<4x1xi32>
    
    // Maximum and conditional operations
    %max_result = "tosa.maximum"(%arg0_max, %arg1_max) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    %c0 = arith.constant dense<0> : tensor<4xi1>
    %select_result = "tosa.select"(%c0, %arg0_max, %max_result) : (tensor<4xi1>, tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    %true_branch = scf.if %cond -> tensor<4xf32> {
      %true_value = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32>
      scf.yield %true_value : tensor<4xf32>
    } else {
      %false_value = arith.constant dense<[5.0, 6.0, 7.0, 8.0]> : tensor<4xf32>
      scf.yield %false_value : tensor<4xf32>
    }
    
    return %concat_result, %ceil_result, %scale_result, %reverse_result, %reduce_result, %true_branch : 
           tensor<6x2xi32>, tensor<?x?xf32>, vector<4xi32>, tensor<2x4xf32>, tensor<4x1xi32>, tensor<4xf32>
  }
}