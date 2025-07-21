module {
  func.func @main(%mat: tensor<3x4xf32>, %vec: tensor<4xf32>, %result: tensor<3xf32>) -> tensor<3xf32> {
    %0 = linalg.matvec 
         ins(%mat, %vec : tensor<3x4xf32>, tensor<4xf32>) 
         outs(%result : tensor<3xf32>) -> tensor<3xf32>
    
    return %0 : tensor<3xf32>
  }
}