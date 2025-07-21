module {
  func.func @main(%input1: tensor<4xf32>, %input2: tensor<4xf32>) -> tensor<4xf32> {
    // Compute the elementwise maximum of input1 and input2
    %0 = "tosa.maximum"(%input1, %input2) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    
    return %0 : tensor<4xf32>
  }
}