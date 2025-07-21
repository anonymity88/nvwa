module {
  func.func @main(%matrices: tensor<2x3x4xf32>, %vectors: tensor<2x4xf32>, %output: tensor<2x3xf32>) -> tensor<2x3xf32> {
    %result = linalg.batch_matvec 
               ins(%matrices, %vectors : tensor<2x3x4xf32>, tensor<2x4xf32>)
               outs(%output : tensor<2x3xf32>) -> tensor<2x3xf32>
    
    return %result : tensor<2x3xf32>
  }
}