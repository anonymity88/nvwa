module {
  func.func @main(%A: tensor<4x4xi32>, %B: tensor<4x4xi32>, %C_init: tensor<4x4xi32>) -> tensor<4x4xi32> {
    %C = linalg.div_unsigned 
         ins(%A, %B : tensor<4x4xi32>, tensor<4x4xi32>) 
         outs(%C_init : tensor<4x4xi32>) -> tensor<4x4xi32>
    
    return %C : tensor<4x4xi32>
  }
}