module {
  func.func @main(%input1: tensor<?x?xf32>, 
                  %input2: tensor<?x?xf32>,
                  %arg0_floor: tensor<4xf32>,
                  %input_reciprocal: tensor<4xf32>,
                  %reshape_input: tensor<?x10xf32>) -> (tensor<?x?xf32>, 
                                                       tensor<4xf32>, 
                                                       tensor<4xf32>, 
                                                       tensor<2x2xf32>, 
                                                       tensor<1x3xi32>, 
                                                       tensor<3x2xf32>,
                                                       tensor<?x5xf32>) {
    // Operations from combined_ops
    %bitwise_or_result = "tosa.bitwise_or"(%input1, %input2) : (tensor<?x?xf32>, tensor<?x?xf32>) -> tensor<?x?xf32>
    
    %floor_result = "tosa.floor"(%arg0_floor) : (tensor<4xf32>) -> tensor<4xf32>
    
    %reciprocal_result = "tosa.reciprocal"(%input_reciprocal) : (tensor<4xf32>) -> tensor<4xf32>
    
    %slice_input = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
    %slice_result = "tosa.slice"(%slice_input) {start = array<i64: 0, 1>, size = array<i64: 2, 2>} : (tensor<2x3xf32>) -> tensor<2x2xf32>
    %slice_final = "tosa.const"() <{value = dense<[[7.0, 8.0], [9.0, 10.0]]> : tensor<2x2xf32>}> : () -> tensor<2x2xf32>
    
    %reduce_prod_input = "tosa.const"() <{value = dense<[[1, 2, 3], [4, 5, 6]]> : tensor<2x3xi32>}> : () -> tensor<2x3xi32>
    %reduce_prod_result = tosa.reduce_prod %reduce_prod_input {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
    
    %reshape_input_inner = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
    %reshape_result = "tosa.reshape"(%reshape_input_inner) {new_shape = array<i64: 3, 2>} : (tensor<2x3xf32>) -> tensor<3x2xf32>
    
    // Call reshape_canonicalize_double
    %reshape_canon_result = call @reshape_canonicalize_double(%reshape_input) : (tensor<?x10xf32>) -> tensor<?x5xf32>
    
    return %bitwise_or_result, %floor_result, %reciprocal_result, %slice_final, %reduce_prod_result, %reshape_result, %reshape_canon_result : 
           tensor<?x?xf32>, tensor<4xf32>, tensor<4xf32>, tensor<2x2xf32>, tensor<1x3xi32>, tensor<3x2xf32>, tensor<?x5xf32>
  }
  
  func.func @reshape_canonicalize_double(%arg0: tensor<?x10xf32>) -> tensor<?x5xf32> {
    %0 = tosa.reshape %arg0 {new_shape = array<i64: 5, -1>}: (tensor<?x10xf32>) -> tensor<5x?xf32>
    %1 = tosa.reshape %0 {new_shape = array<i64: -1, 5>}: (tensor<5x?xf32>) -> tensor<?x5xf32>
    return %1 : tensor<?x5xf32>
  }
}