module {
  func.func @main(
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
      %cond: i1,
      %conv_input: tensor<1x32x32x8xf32>,
      %conv_weights: tensor<2x2x8x8xf32>,
      %conv_bias: tensor<64xf32>
  ) -> (tensor<6x2xi32>, tensor<?x?xf32>, vector<4xi32>, tensor<2x4xf32>, tensor<4x1xi32>, tensor<4xf32>, tensor<1x32x32x64xf32>) {
    // Concat operation
    %concat_result = "tosa.concat"(%input1_concat, %input2_concat) {axis = 0 : i32} : (tensor<4x2xi32>, tensor<2x2xi32>) -> tensor<6x2xi32>
    
    // Ceil operation
    %ceil_result = "tosa.ceil"(%input_ceil) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Scale operation
    %scale_result = tosa.apply_scale %arg0_scale, %arg1_scale, %arg2_scale {double_round = true} : (vector<4xi32>, vector<4xi32>, vector<4xi8>) -> vector<4xi32>
    
    // Reverse operations
    %reverse_result = "tosa.reverse"(%arg0_reverse) {axis = 1 : i32} : (tensor<2x4xf32>) -> tensor<2x4xf32>
    %max_reverse_result = "tosa.maximum"(%arg0_reverse, %arg0_reverse) : (tensor<2x4xf32>, tensor<2x4xf32>) -> tensor<2x4xf32>
    
    // Reduce operation
    %reduce_result = "tosa.reduce_min"(%input_reduce) {axis = 1 : i32} : (tensor<4x3xi32>) -> tensor<4x1xi32>
    
    // Max and select operations
    %max_result = "tosa.maximum"(%arg0_max, %arg1_max) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    %c0 = arith.constant dense<0> : tensor<4xi1>
    %select_result = "tosa.select"(%c0, %arg0_max, %max_result) : (tensor<4xi1>, tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    
    // Conditional branch
    %true_branch = scf.if %cond -> tensor<4xf32> {
      %true_value = arith.constant dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32>
      scf.yield %true_value : tensor<4xf32>
    } else {
      %false_value = arith.constant dense<[5.0, 6.0, 7.0, 8.0]> : tensor<4xf32>
      scf.yield %false_value : tensor<4xf32>
    }
    
    // Call depthwise convolution function
    %conv_result = call @test_depthwise_conv2d_pad_bottom(%conv_input, %conv_weights, %conv_bias) : 
                  (tensor<1x32x32x8xf32>, tensor<2x2x8x8xf32>, tensor<64xf32>) -> tensor<1x32x32x64xf32>
    
    return %concat_result, %ceil_result, %scale_result, %reverse_result, %reduce_result, %true_branch, %conv_result : 
           tensor<6x2xi32>, tensor<?x?xf32>, vector<4xi32>, tensor<2x4xf32>, tensor<4x1xi32>, tensor<4xf32>, tensor<1x32x32x64xf32>
  }

  func.func @test_depthwise_conv2d_pad_bottom(%arg0: tensor<1x32x32x8xf32>, %arg1: tensor<2x2x8x8xf32>, %arg2: tensor<64xf32>) -> tensor<1x32x32x64xf32> {
    %0 = "tosa.depthwise_conv2d"(%arg0, %arg1, %arg2) {dilation = array<i64: 1, 1>, pad = array<i64: 0, 8193, 0, 1>, stride = array<i64: 1, 1>} :
              (tensor<1x32x32x8xf32>, tensor<2x2x8x8xf32>, tensor<64xf32>) -> tensor<1x32x32x64xf32>
    return %0 : tensor<1x32x32x64xf32>
  }
}