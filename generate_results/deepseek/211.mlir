module {
  func.func @combined_main(%arg0_reverse: tensor<2x4xf32>,
                          %arg1_reverse: tensor<4xf32>,
                          %axis: i32,
                          %input1_add: tensor<12x6xf32>,
                          %input2_add: tensor<12x6xf32>,
                          %arg0_pool: tensor<1x3x32x32xf32>,
                          %input_conv: tensor<1x32x32x8xf32>,
                          %filter: tensor<16x8x3x3xf32>,
                          %bias: tensor<16xf32>,
                          %arg0_ge: tensor<4xi32>,
                          %arg1_ge: tensor<4xi32>,
                          %arg0_gt: tensor<4xi32>,
                          %arg1_gt: tensor<4xi32>) -> (tensor<2x4xf32>,
                                                      tensor<12x6xf32>,
                                                      tensor<1x3x30x30xf32>,
                                                      tensor<1x34x34x16xf32>,
                                                      tensor<4xi1>,
                                                      tensor<4xi1>) {
    // Reverse operation
    %reverse_result = "tosa.reverse"(%arg0_reverse) {axis = 1 : i32} : (tensor<2x4xf32>) -> tensor<2x4xf32>
    // Maximum operation
    %max_result = "tosa.maximum"(%arg0_reverse, %arg0_reverse) : (tensor<2x4xf32>, tensor<2x4xf32>) -> tensor<2x4xf32>
    
    // Add operation
    %add_result = "tosa.add"(%input1_add, %input2_add) : (tensor<12x6xf32>, tensor<12x6xf32>) -> tensor<12x6xf32>
    
    // Avg Pool example
    %pool_result = tosa.avg_pool2d %arg0_pool {pad = array<i64: 1, 1, 1, 1>, kernel = array<i64: 3, 3>, stride = array<i64: 1, 1>, acc_type = f32} : (tensor<1x3x32x32xf32>) -> tensor<1x3x30x30xf32>
    %const_pool = "tosa.const"() <{value = dense<[[1.0]]> : tensor<1x1xf32>}> : () -> tensor<1x1xf32>
    %pool_final = tosa.add %pool_result, %const_pool : (tensor<1x3x30x30xf32>, tensor<1x1xf32>) -> tensor<1x3x30x30xf32>
    
    // Transpose Conv2D example
    %conv_result = "tosa.transpose_conv2d"(%input_conv, %filter, %bias) {out_pad = array<i64: 1, 1, 1, 1>, stride = array<i64: 1, 1>, out_shape = array<i64: 1, 34, 34, 16>} : (tensor<1x32x32x8xf32>, tensor<16x8x3x3xf32>, tensor<16xf32>) -> tensor<1x34x34x16xf32>
    
    // Greater Equal operation
    %ge_result = "tosa.greater_equal"(%arg0_ge, %arg1_ge) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
    
    // Greater operation
    %gt_result = "tosa.greater"(%arg0_gt, %arg1_gt) : (tensor<4xi32>, tensor<4xi32>) -> tensor<4xi1>
    
    return %reverse_result, %add_result, %pool_final, %conv_result, %ge_result, %gt_result : 
           tensor<2x4xf32>, tensor<12x6xf32>, tensor<1x3x30x30xf32>, tensor<1x34x34x16xf32>, tensor<4xi1>, tensor<4xi1>
  }
}