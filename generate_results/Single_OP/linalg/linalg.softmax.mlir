module {
  func.func @main(%input: tensor<4x3xf32>, %output: tensor<4x3xf32>) -> tensor<4x3xf32> {
    %0 = linalg.softmax 
         dimension(1) 
         ins(%input : tensor<4x3xf32>)
         outs(%output : tensor<4x3xf32>) -> tensor<4x3xf32>

    return %0 : tensor<4x3xf32>
  }
}