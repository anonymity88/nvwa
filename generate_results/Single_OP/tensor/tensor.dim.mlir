module {
  func.func @main(%A: tensor<4x?xf32>) -> (index, index) {
    // Always returns the size of the first dimension (which is 4) 
    %c0 = arith.constant 0 : index
    %x = tensor.dim %A, %c0 : tensor<4x?xf32>
    
    // Return the size of the second dimension, which is dynamic
    %c1 = arith.constant 1 : index
    %y = tensor.dim %A, %c1 : tensor<4x?xf32>

    return %x, %y : index, index
  }
}