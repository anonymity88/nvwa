module {
  func.func @combined_main(
      %input1_logical_or: tensor<?x?xi1>,
      %input2_logical_or: tensor<?x?xi1>,
      %input_fc: tensor<?x?xf32>,
      %weight_fc: tensor<?x?xf32>,
      %bias_fc: tensor<?xf32>,
      %input_tanh: tensor<4xi32>,
      %values_gather: tensor<4x8x16xf32>,
      %indices_gather: tensor<2x3xi32>,
      %input1_shift: tensor<?x?xi32>,
      %input2_shift: tensor<?x?xi32>,
      %input_ceil: tensor<?x?xf32>
  ) -> (tensor<?x?xi1>, tensor<?x?xf32>, tensor<4xi32>, tensor<2x3x16xf32>, tensor<?x?xi32>, tensor<?x?xf32>) {
    // Logical OR operation
    %logical_or_result = "tosa.logical_or"(%input1_logical_or, %input2_logical_or) : (tensor<?x?xi1>, tensor<?x?xi1>) -> tensor<?x?xi1>
    
    // Fully connected operation
    %fc_result = "tosa.fully_connected"(%input_fc, %weight_fc, %bias_fc) : (tensor<?x?xf32>, tensor<?x?xf32>, tensor<?xf32>) -> tensor<?x?xf32>
    
    // Tanh operation
    %tanh_result = "tosa.tanh"(%input_tanh) : (tensor<4xi32>) -> tensor<4xi32>
    
    // Gather operation
    %gather_result = "tosa.gather"(%values_gather, %indices_gather) : (tensor<4x8x16xf32>, tensor<2x3xi32>) -> tensor<2x3x16xf32>
    
    // Logical right shift operation
    %shift_result = "tosa.logical_right_shift"(%input1_shift, %input2_shift) : (tensor<?x?xi32>, tensor<?x?xi32>) -> tensor<?x?xi32>
    
    // Ceil operation
    %ceil_result = "tosa.ceil"(%input_ceil) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    
    return %logical_or_result, %fc_result, %tanh_result, %gather_result, %shift_result, %ceil_result : 
           tensor<?x?xi1>, tensor<?x?xf32>, tensor<4xi32>, tensor<2x3x16xf32>, tensor<?x?xi32>, tensor<?x?xf32>
  }
}