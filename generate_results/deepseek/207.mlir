module {
  func.func @combined_ops(%input1: tensor<?x?xf32>, 
                          %input2: tensor<?x?xf32>,
                          %arg0_floor: tensor<4xf32>,
                          %input_reciprocal: tensor<4xf32>) -> (tensor<?x?xf32>, 
                                                               tensor<4xf32>, 
                                                               tensor<4xf32>, 
                                                               tensor<2x2xf32>, 
                                                               tensor<1x3xi32>, 
                                                               tensor<3x2xf32>) {
    // Bitwise OR operation
    %bitwise_or_result = "tosa.bitwise_or"(%input1, %input2) : (tensor<?x?xf32>, tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Floor operation
    %floor_result = "tosa.floor"(%arg0_floor) : (tensor<4xf32>) -> tensor<4xf32>
    
    // Reciprocal operation
    %reciprocal_result = "tosa.reciprocal"(%input_reciprocal) : (tensor<4xf32>) -> tensor<4xf32>
    
    // Slice example
    %slice_input = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
    %slice_result = "tosa.slice"(%slice_input) {start = array<i64: 0, 1>, size = array<i64: 2, 2>} : (tensor<2x3xf32>) -> tensor<2x2xf32>
    %slice_final = "tosa.const"() <{value = dense<[[7.0, 8.0], [9.0, 10.0]]> : tensor<2x2xf32>}> : () -> tensor<2x2xf32>
    
    // Reduce Prod example
    %reduce_prod_input = "tosa.const"() <{value = dense<[[1, 2, 3], [4, 5, 6]]> : tensor<2x3xi32>}> : () -> tensor<2x3xi32>
    %reduce_prod_result = tosa.reduce_prod %reduce_prod_input {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
    
    // Reshape example
    %reshape_input = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
    %reshape_result = "tosa.reshape"(%reshape_input) {new_shape = array<i64: 3, 2>} : (tensor<2x3xf32>) -> tensor<3x2xf32>
    
    return %bitwise_or_result, %floor_result, %reciprocal_result, %slice_final, %reduce_prod_result, %reshape_result : 
           tensor<?x?xf32>, tensor<4xf32>, tensor<4xf32>, tensor<2x2xf32>, tensor<1x3xi32>, tensor<3x2xf32>
  }
}