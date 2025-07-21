module {
  func.func @main(%input1: tensor<2x3xf32>, %input2: tensor<2x3xf32>, %output: tensor<2x3xf32>) -> tensor<2x3xf32> {
    %result = linalg.div 
         ins(%input1, %input2 : tensor<2x3xf32>, tensor<2x3xf32>) 
         outs(%output : tensor<2x3xf32>) -> tensor<2x3xf32>

    return %result : tensor<2x3xf32>
  }
}