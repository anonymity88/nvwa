module {
  func.func @main(%arg0: !shape.shape, %arg1: !shape.shape) -> !shape.shape {
    %result = shape.meet %arg0, %arg1 : !shape.shape, !shape.shape -> !shape.shape
    return %result : !shape.shape
  }
}