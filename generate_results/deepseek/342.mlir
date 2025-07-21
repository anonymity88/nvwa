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
  ) -> (tensor<2x3x5xf32>, tensor<2x3xf32>, tensor<4x3xf32>) {
    %matmul_result = call @batch_matmul_tensor(%a_matmul, %b_matmul, %output_matmul) 
                     : (tensor<2x3x4xf32>, tensor<2x4x5xf32>, tensor<2x3x5xf32>) -> tensor<2x3x5xf32>
    
    %ceil_result = call @ceil_tensor(%input_ceil, %output_ceil) 
                   : (tensor<2x3xf32>, tensor<2x3xf32>) -> tensor<2x3xf32>
    
    %softmax_result = call @softmax_tensor(%input_softmax, %output_softmax) 
                      : (tensor<4x3xf32>, tensor<4x3xf32>) -> tensor<4x3xf32>
    
    return %matmul_result, %ceil_result, %softmax_result : tensor<2x3x5xf32>, tensor<2x3xf32>, tensor<4x3xf32>
  }

  transform.sequence failures(propagate) {
  ^bb1(%arg1: !transform.any_op):
    %3 = transform.structured.match ops{["linalg.generic"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    %4 = transform.get_parent_op %3 {isolated_from_above} : (!transform.any_op) -> !transform.any_op
    %5 = transform.structured.vectorize_children_and_apply_patterns %4 : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}