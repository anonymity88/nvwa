module {
  func.func @main(%dim1: index, %dim2: index) -> tensor<?x?xf32> {
    // Creating an empty tensor of dynamic shape
    %empty_tensor = tensor.empty(%dim1, %dim2) : tensor<?x?xf32>
    
    return %empty_tensor : tensor<?x?xf32>
  }
}