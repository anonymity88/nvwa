module {
  func.func @main(%vec: tensor<4xf32>, %mat: tensor<4x3xf32>, %result: tensor<3xf32>) -> tensor<3xf32> {
    %0 = linalg.vecmat 
         ins(%vec, %mat : tensor<4xf32>, tensor<4x3xf32>) 
         outs(%result : tensor<3xf32>) -> tensor<3xf32>
    
    return %0 : tensor<3xf32>
  }
}