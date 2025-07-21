module {
  func.func @main(%input_clamp: tensor<4xf32>,
                  %values_in: tensor<3x4x5xf32>,
                  %indices: tensor<2x3xi32>,
                  %input_scatter: tensor<3x4x5xf32>,
                  %input_negate: tensor<?x?xf32>,
                  %input_xor1: tensor<?x?x?xi1>,
                  %input_xor2: tensor<?x?x?xi1>,
                  %input_identity: tensor<?x?xf32>) -> (tensor<4xf32>,
                                                        tensor<3x4x5xf32>,
                                                        tensor<?x?xf32>,
                                                        tensor<3x2xf32>,
                                                        tensor<?x?x?xi1>,
                                                        tensor<?x?xf32>,
                                                        tensor<1x3xi32>) {
    // Clamp operation
    %clamp_result = "tosa.clamp"(%input_clamp) {min_int = 0 : i64, max_int = 255 : i64, min_fp = 0.0 : f64, max_fp = 1.0 : f64} : (tensor<4xf32>) -> tensor<4xf32>
    
    // Scatter operation
    %scatter_result = "tosa.scatter"(%values_in, %indices, %input_scatter) : (tensor<3x4x5xf32>, tensor<2x3xi32>, tensor<3x4x5xf32>) -> tensor<3x4x5xf32>
    
    // Negate operation
    %negate_result = "tosa.negate"(%input_negate) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Reshape operation
    %input_tensor = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
    %reshaped_tensor = "tosa.reshape"(%input_tensor) {new_shape = array<i64: 3, 2>} : (tensor<2x3xf32>) -> tensor<3x2xf32>
    
    // Logical XOR operation
    %xor_result = "tosa.logical_xor"(%input_xor1, %input_xor2) : (tensor<?x?x?xi1>, tensor<?x?x?xi1>) -> tensor<?x?x?xi1>
    
    // Identity operation
    %identity_result = "tosa.identity"(%input_identity) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Call reduce_max_constant function
    %reduce_result = call @reduce_max_constant() : () -> tensor<1x3xi32>
    
    return %clamp_result, %scatter_result, %negate_result, %reshaped_tensor, %xor_result, %identity_result, %reduce_result : 
           tensor<4xf32>, tensor<3x4x5xf32>, tensor<?x?xf32>, tensor<3x2xf32>, tensor<?x?x?xi1>, tensor<?x?xf32>, tensor<1x3xi32>
  }
  
  func.func @reduce_max_constant() -> tensor<1x3xi32> {
    %const = "tosa.const"() <{value = dense<[[1,2,3], [4,5,6]]> : tensor<2x3xi32>}> : () -> tensor<2x3xi32>
    %0 = tosa.reduce_max %const {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
    return %0 : tensor<1x3xi32>
  }
}