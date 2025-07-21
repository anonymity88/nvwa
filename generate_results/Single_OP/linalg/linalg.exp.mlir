module {
  func.func @main(%A: tensor<4x4xf32>, %C_init: tensor<4x4xf32>) -> tensor<4x4xf32> {
    %C = linalg.exp 
         ins(%A : tensor<4x4xf32>)
         outs(%C_init : tensor<4x4xf32>) -> tensor<4x4xf32>

    return %C : tensor<4x4xf32>
  }
}