module {
  func.func @combined_ops(%values_gather: tensor<4x8x16xf32>, 
                          %indices_gather: tensor<2x3xi32>,
                          %input1_max: tensor<4xf32>,
                          %input2_max: tensor<4xf32>,
                          %input_negate: tensor<?x?xf32>,
                          %input_xor1: tensor<?x?x?xi1>,
                          %input_xor2: tensor<?x?x?xi1>,
                          %arg_resize: tensor<1x28x28x3xf32>,
                          %values_scatter: tensor<3x4x5xf32>,
                          %indices_scatter: tensor<2x3xi32>,
                          %input_scatter: tensor<3x4x5xf32>) -> (tensor<2x3x16xf32>,
                                                                 tensor<4xf32>,
                                                                 tensor<?x?xf32>,
                                                                 tensor<?x?x?xi1>,
                                                                 tensor<1x56x56x3xf32>,
                                                                 tensor<3x4x5xf32>) {
    // Gather operation
    %gather_result = "tosa.gather"(%values_gather, %indices_gather) : (tensor<4x8x16xf32>, tensor<2x3xi32>) -> tensor<2x3x16xf32>
    
    // Maximum operation
    %max_result = "tosa.maximum"(%input1_max, %input2_max) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    
    // Negate operation
    %negate_result = "tosa.negate"(%input_negate) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    // Logical XOR operation
    %xor_result = "tosa.logical_xor"(%input_xor1, %input_xor2) : (tensor<?x?x?xi1>, tensor<?x?x?xi1>) -> tensor<?x?x?xi1>
    
    // Resize operation
    %resize_result = "tosa.resize"(%arg_resize) {scale = array<i64: 2, 2, 1, 1>, offset = array<i64: 0, 0>, border = array<i64: 0, 0>, mode = "BILINEAR"} : (tensor<1x28x28x3xf32>) -> tensor<1x56x56x3xf32>
    
    // Scatter operation
    %scatter_result = "tosa.scatter"(%values_scatter, %indices_scatter, %input_scatter) : (tensor<3x4x5xf32>, tensor<2x3xi32>, tensor<3x4x5xf32>) -> tensor<3x4x5xf32>
    
    return %gather_result, %max_result, %negate_result, %xor_result, %resize_result, %scatter_result : 
           tensor<2x3x16xf32>, tensor<4xf32>, tensor<?x?xf32>, tensor<?x?x?xi1>, tensor<1x56x56x3xf32>, tensor<3x4x5xf32>
  }
}