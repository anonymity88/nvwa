module {
  func.func @main(%arg0: !shape.value_shape, %arg1: !shape.shape) -> !shape.value_shape {
    %result = shape.with_shape %arg0, %arg1 : !shape.value_shape, !shape.shape
    return %result : !shape.value_shape
  }
}