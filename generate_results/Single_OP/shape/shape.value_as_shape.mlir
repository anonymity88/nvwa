module {
  func.func @main(%arg0: tensor<2xi32>) -> !shape.shape {
    %result = shape.value_as_shape %arg0 : tensor<2xi32> -> !shape.shape
    return %result : !shape.shape
  }
}