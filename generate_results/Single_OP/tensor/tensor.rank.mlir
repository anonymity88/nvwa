module {
  func.func @main(%arg0: tensor<4x?x?xf32>, %arg1: tensor<*xf32>) -> (index, index) {
    %rank0 = tensor.rank %arg0 : tensor<4x?x?xf32>
    %rank1 = tensor.rank %arg1 : tensor<*xf32>
    return %rank0, %rank1 : index, index
  }
}