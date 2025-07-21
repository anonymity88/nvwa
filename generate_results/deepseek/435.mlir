module {
  func.func @main(
      %input_pool: tensor<1x28x28x3xf32>,
      %input_ceil: tensor<?x?xf32>,
      %input_bitwise1: tensor<?x?xf32>,
      %input_bitwise2: tensor<?x?xf32>,
      %input_logical1: tensor<?x?xi1>,
      %input_logical2: tensor<?x?xi1>,
      %arg0_mul: tensor<i32>
  ) -> (tensor<1x14x14x3xf32>, tensor<?x?xf32>, tensor<?x?xf32>, tensor<3x2xf32>, tensor<1x3xi32>, tensor<?x?xi1>, tensor<i32>) {
    // Pooling operation
    %pool_result = "tosa.max_pool2d"(%input_pool) {
      kernel = array<i64: 2, 2>,
      stride = array<i64: 2, 2>,
      pad = array<i64: 0, 0, 0, 0>
    } : (tensor<1x28x28x3xf32>) -> tensor<1x14x14x3xf32>

    // Ceiling operation
    %ceil_result = "tosa.ceil"(%input_ceil) : (tensor<?x?xf32>) -> tensor<?x?xf32>

    // Bitwise OR operation
    %bitwise_result = "tosa.bitwise_or"(%input_bitwise1, %input_bitwise2) : (tensor<?x?xf32>, tensor<?x?xf32>) -> tensor<?x?xf32>

    // Reshape operation
    %const_reshape = "tosa.const"() {
      value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>
    } : () -> tensor<2x3xf32>
    %reshape_result = "tosa.reshape"(%const_reshape) {
      new_shape = array<i64: 3, 2>
    } : (tensor<2x3xf32>) -> tensor<3x2xf32>

    // Reduce operation
    %const_reduce = "tosa.const"() {
      value = dense<[[1, 3, 5], [2, 4, 6]]> : tensor<2x3xi32>
    } : () -> tensor<2x3xi32>
    %reduce_result = "tosa.reduce_max"(%const_reduce) {
      axis = 0 : i32
    } : (tensor<2x3xi32>) -> tensor<1x3xi32>

    // Logical AND operation
    %logical_result = "tosa.logical_and"(%input_logical1, %input_logical2) : (tensor<?x?xi1>, tensor<?x?xi1>) -> tensor<?x?xi1>

    // Call fold_mul_one_lhs_i32 function
    %mul_result = call @fold_mul_one_lhs_i32(%arg0_mul) : (tensor<i32>) -> tensor<i32>

    return %pool_result, %ceil_result, %bitwise_result, %reshape_result, %reduce_result, %logical_result, %mul_result : 
           tensor<1x14x14x3xf32>, tensor<?x?xf32>, tensor<?x?xf32>, tensor<3x2xf32>, tensor<1x3xi32>, tensor<?x?xi1>, tensor<i32>
  }

  func.func @fold_mul_one_lhs_i32(%arg0: tensor<i32>) -> tensor<i32> {
    %one = "tosa.const"() {value = dense<64> : tensor<i32>} : () -> tensor<i32>
    %mul = tosa.mul %one, %arg0 {shift = 6 : i8} : (tensor<i32>, tensor<i32>) -> tensor<i32>
    return %mul : tensor<i32>
  }
}