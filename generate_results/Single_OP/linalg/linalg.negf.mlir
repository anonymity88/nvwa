module {
  func.func @main(%input: tensor<2x3xf32>, %output: tensor<2x3xf32>) -> tensor<2x3xf32> {
    %0 = linalg.negf 
         ins(%input : tensor<2x3xf32>)
         outs(%output : tensor<2x3xf32>) -> tensor<2x3xf32>
    
    return %0 : tensor<2x3xf32>
  }
}