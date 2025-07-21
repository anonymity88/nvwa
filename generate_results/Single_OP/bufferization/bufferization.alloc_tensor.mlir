module {
  func.func @main(%d1: index, %d2: index, %a: tensor<?x?xf32>, %b: tensor<?x?xf32>) -> tensor<?x?xf32> {
    // Allocate a new tensor using bufferization.alloc_tensor with dynamic sizes
    %c = bufferization.alloc_tensor(%d1, %d2) : tensor<?x?xf32>

    // Perform matrix multiplication and store the result in the allocated tensor
    %result = linalg.matmul
      ins(%a, %b: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%c: tensor<?x?xf32>) -> tensor<?x?xf32>

    return %result : tensor<?x?xf32>
  }

  func.func @main_with_hint(%d1: index, %d2: index, %noe: index, %a: tensor<?x?xf32>, %b: tensor<?x?xf32>) -> tensor<?x?xf32> {
    // Allocate a new tensor using bufferization.alloc_tensor with a size hint
    %c = bufferization.alloc_tensor(%d1, %d2) size_hint = %noe
      : tensor<?x?xf32>

    // Perform matrix multiplication and store the result in the allocated tensor
    %result = linalg.matmul
      ins(%a, %b: tensor<?x?xf32>, tensor<?x?xf32>)
      outs(%c: tensor<?x?xf32>) -> tensor<?x?xf32>

    return %result : tensor<?x?xf32>
  }
}