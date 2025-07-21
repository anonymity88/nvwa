module {
  func.func @batch_matmul_tensor(%a: tensor<2x3x4xf32>, %b: tensor<2x4x5xf32>, %output: tensor<2x3x5xf32>) -> tensor<2x3x5xf32> {
    %0 = linalg.batch_matmul ins(%a, %b : tensor<2x3x4xf32>, tensor<2x4x5xf32>) 
                              outs(%output : tensor<2x3x5xf32>) -> tensor<2x3x5xf32>
    return %0 : tensor<2x3x5xf32>
  }

  func.func @ceil_tensor(%input: tensor<2x3xf32>, %output: tensor<2x3xf32>) -> tensor<2x3xf32> {
    %0 = linalg.ceil 
         ins(%input : tensor<2x3xf32>)
         outs(%output : tensor<2x3xf32>) -> tensor<2x3xf32>
    return %0 : tensor<2x3xf32>
  }

  func.func @softmax_tensor(%input: tensor<4x3xf32>, %output: tensor<4x3xf32>) -> tensor<4x3xf32> {
    %0 = linalg.softmax 
         dimension(1) 
         ins(%input : tensor<4x3xf32>)
         outs(%output : tensor<4x3xf32>) -> tensor<4x3xf32>
    return %0 : tensor<4x3xf32>
  }

  func.func @main(
    %a_matmul: tensor<2x3x4xf32>, 
    %b_matmul: tensor<2x4x5xf32>, 
    %output_matmul: tensor<2x3x5xf32>,
    %input_ceil: tensor<2x3xf32>, 
    %output_ceil: tensor<2x3xf32>,
    %input_softmax: tensor<4x3xf32>, 
    %output_softmax: tensor<4x3xf32>
  ) -> tensor<2x3x5xf32> {
    // First perform batch matrix multiplication
    %matmul_result = call @batch_matmul_tensor(%a_matmul, %b_matmul, %output_matmul) 
                     : (tensor<2x3x4xf32>, tensor<2x4x5xf32>, tensor<2x3x5xf32>) -> tensor<2x3x5xf32>
    
    // Then perform ceil operation
    %ceil_result = call @ceil_tensor(%input_ceil, %output_ceil) 
                   : (tensor<2x3xf32>, tensor<2x3xf32>) -> tensor<2x3xf32>
    
    // Finally perform softmax operation
    %softmax_result = call @softmax_tensor(%input_softmax, %output_softmax) 
                      : (tensor<4x3xf32>, tensor<4x3xf32>) -> tensor<4x3xf32>
    
    // Return the batch matmul result as the main output
    return %matmul_result : tensor<2x3x5xf32>
  }
}