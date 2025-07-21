module {
  func.func @main(%arg0: tensor<5xindex>) -> !shape.shape {
    %result = shape.from_extent_tensor %arg0 : tensor<5xindex>
    return %result : !shape.shape
  }
}