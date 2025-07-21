module {
  func.func @main(%A: tensor<2x3xf32>, %B: tensor<3x4xf32>, %C_init: tensor<2x4xf32>) -> tensor<2x4xf32> {
    %C = linalg.matmul 
         ins(%A, %B : tensor<2x3xf32>, tensor<3x4xf32>)
         outs(%C_init : tensor<2x4xf32>) -> tensor<2x4xf32>

    return %C : tensor<2x4xf32>
  }
}