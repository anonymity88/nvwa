module {
  func.func @main(%input_table: tensor<4xf32>, 
                  %table: tensor<1xf32>,
                  %input_fc: tensor<?x?xf32>,
                  %weight: tensor<?x?xf32>,
                  %bias: tensor<?xf32>,
                  %input_bitwise: tensor<?x?xi32>,
                  %input_clamp: tensor<4xf32>,
                  %input_log: tensor<?x?xf32>,
                  %arg0_transpose: tensor<1x2x3x4xi32>,
                  %arg1_transpose: tensor<1x2x3x4xi32>) -> (tensor<4xf32>,
                                                           tensor<?x?xf32>,
                                                           tensor<?x?xi32>,
                                                           tensor<4xf32>,
                                                           tensor<3x2xf32>,
                                                           tensor<?x?xf32>,
                                                           tensor<1x2x3x4xi32>) {
    // Table lookup operation
    %table_result = "tosa.table"(%input_table, %table) : (tensor<4xf32>, tensor<1xf32>) -> tensor<4xf32>
    
    // Fully connected layer
    %fc_result = "tosa.fully_connected"(%input_fc, %weight, %bias) : (tensor<?x?xf32>, tensor<?x?xf32>, tensor<?xf32>) -> tensor<?x?xf32>
    
    // Bitwise operation
    %bitwise_result = "tosa.bitwise_not"(%input_bitwise) : (tensor<?x?xi32>) -> tensor<?x?xi32>
    
    // Clamp operation
    %clamp_result = "tosa.clamp"(%input_clamp) {min_int = 0 : i64, max_int = 255 : i64, min_fp = 0.0 : f64, max_fp = 1.0 : f64} : (tensor<4xf32>) -> tensor<4xf32>
    
    // Reshape operation
    %input_reshape = "tosa.const"() {value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>} : () -> tensor<2x3xf32>
    %reshape_result = "tosa.reshape"(%input_reshape) {new_shape = array<i64: 3, 2>} : (tensor<2x3xf32>) -> tensor<3x2xf32>
    
    // Log operation
    %log_result = "tosa.log"(%input_log) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Call transpose function
    %transpose_result = call @test_transpose_tracks_to_nullifying_diverging_binary(%arg0_transpose, %arg1_transpose) : (tensor<1x2x3x4xi32>, tensor<1x2x3x4xi32>) -> tensor<1x2x3x4xi32>
    
    return %table_result, %fc_result, %bitwise_result, %clamp_result, %reshape_result, %log_result, %transpose_result : 
           tensor<4xf32>, tensor<?x?xf32>, tensor<?x?xi32>, tensor<4xf32>, tensor<3x2xf32>, tensor<?x?xf32>, tensor<1x2x3x4xi32>
  }

  func.func @test_transpose_tracks_to_nullifying_diverging_binary(%arg0: tensor<1x2x3x4xi32>, %arg1: tensor<1x2x3x4xi32>) -> tensor<1x2x3x4xi32> {
    %perms0 = "tosa.const"() {value = dense<[0, 2, 3, 1]> : tensor<4xi32>} : () -> tensor<4xi32>
    %transpose0 = tosa.transpose %arg0, %perms0 : (tensor<1x2x3x4xi32>, tensor<4xi32>) -> tensor<1x3x4x2xi32>
    %transpose1 = tosa.transpose %arg1, %perms0 : (tensor<1x2x3x4xi32>, tensor<4xi32>) -> tensor<1x3x4x2xi32>
    %clamp = tosa.clamp %transpose0 {max_fp = 1.0 : f32, min_fp = 0.0 : f32, max_int = 1 : i64, min_int = 0 : i64} : (tensor<1x3x4x2xi32>) -> tensor<1x3x4x2xi32>
    %abs = tosa.abs %transpose1 : (tensor<1x3x4x2xi32>) -> tensor<1x3x4x2xi32>
    %add = tosa.add %clamp, %abs : (tensor<1x3x4x2xi32>, tensor<1x3x4x2xi32>) -> tensor<1x3x4x2xi32>
    %perms1 = "tosa.const"() {value = dense<[0, 3, 1, 2]> : tensor<4xi32>} : () -> tensor<4xi32>
    %result = tosa.transpose %add, %perms1 : (tensor<1x3x4x2xi32>, tensor<4xi32>) -> tensor<1x2x3x4xi32>
    return %result : tensor<1x2x3x4xi32>
  }
}