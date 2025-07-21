module {
  func.func @main(%arg0: tensor<3x4xf32>, %arg1: index) -> index {
    %result = shape.dim %arg0, %arg1 : tensor<3x4xf32>, index -> index
    return %result : index
  }
}