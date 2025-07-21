module attributes {transform.with_named_sequence} {
  func.func @pooling_ncw_max_tensor(%input: tensor<1x1x4xf32>) -> tensor<1x1x2xf32> {
    %fake = tensor.empty() : tensor<3xf32>
    %init = tensor.empty() : tensor<1x1x2xf32>
    %cst = arith.constant 0.000000e+00 : f32
    %fill = linalg.fill ins(%cst : f32) outs(%init : tensor<1x1x2xf32>) -> tensor<1x1x2xf32>
    %res = linalg.pooling_ncw_max {dilations = dense<1> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>}
      ins(%input, %fake: tensor<1x1x4xf32>, tensor<3xf32>)
      outs(%fill: tensor<1x1x2xf32>) -> tensor<1x1x2xf32>
    return %res : tensor<1x1x2xf32>
  }

  func.func @max_tensor(%A: tensor<3x4xf32>, %B: tensor<3x4xf32>, %C_init: tensor<3x4xf32>) -> tensor<3x4xf32> {
    %C = linalg.max
         ins(%A, %B : tensor<3x4xf32>, tensor<3x4xf32>)
         outs(%C_init : tensor<3x4xf32>) -> tensor<3x4xf32>
    return %C : tensor<3x4xf32>
  }

  func.func @batch_matmul_tensor(%a: tensor<2x3x4xf32>, %b: tensor<2x4x5xf32>, %output: tensor<2x3x5xf32>) -> tensor<2x3x5xf32> {
    %0 = linalg.batch_matmul ins(%a, %b : tensor<2x3x4xf32>, tensor<2x4x5xf32>) 
                              outs(%output : tensor<2x3x5xf32>) -> tensor<2x3x5xf32>
    return %0 : tensor<2x3x5xf32>
  }

  func.func @main(
    %input_pool: tensor<1x1x4xf32>,
    %A_max: tensor<3x4xf32>,
    %B_max: tensor<3x4xf32>,
    %C_init_max: tensor<3x4xf32>,
    %a_matmul: tensor<2x3x4xf32>,
    %b_matmul: tensor<2x4x5xf32>,
    %output_matmul: tensor<2x3x5xf32>
  ) -> (tensor<1x1x2xf32>, tensor<3x4xf32>, tensor<2x3x5xf32>) {
    %pool_result = call @pooling_ncw_max_tensor(%input_pool) : (tensor<1x1x4xf32>) -> tensor<1x1x2xf32>
    
    %max_result = call @max_tensor(%A_max, %B_max, %C_init_max) : (tensor<3x4xf32>, tensor<3x4xf32>, tensor<3x4xf32>) -> tensor<3x4xf32>
    
    %matmul_result = call @batch_matmul_tensor(%a_matmul, %b_matmul, %output_matmul) : (tensor<2x3x4xf32>, tensor<2x4x5xf32>, tensor<2x3x5xf32>) -> tensor<2x3x5xf32>
    
    return %pool_result, %max_result, %matmul_result : tensor<1x1x2xf32>, tensor<3x4xf32>, tensor<2x3x5xf32>
  }

  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.matmul"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    %1, %loops:3 = transform.structured.tile_using_for %0 tile_sizes [16, 16, 16] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
    %2 = transform.structured.promote %1 { operands_to_promote = [0, 1], mapping = [#gpu.memory_space<private>] } : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}