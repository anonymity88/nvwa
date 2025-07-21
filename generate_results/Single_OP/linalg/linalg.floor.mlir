module {
  func.func @main(%A: tensor<3x4xf32>, %C_init: tensor<3x4xf32>) -> tensor<3x4xf32> {
    %C = linalg.floor 
         ins(%A : tensor<3x4xf32>)
         outs(%C_init : tensor<3x4xf32>) -> tensor<3x4xf32>

    return %C : tensor<3x4xf32>
  }
}