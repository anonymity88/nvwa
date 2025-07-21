module {
  func.func @main(
    %A: tensor<4x3xf32>, 
    %B: tensor<4x2xf32>, 
    %C_init: tensor<3x2xf32>
  ) -> tensor<3x2xf32> {
    %C = linalg.matmul_transpose_a 
         ins(%A, %B : tensor<4x3xf32>, tensor<4x2xf32>)
         outs(%C_init : tensor<3x2xf32>) -> tensor<3x2xf32>

    return %C : tensor<3x2xf32>
  }
}