module {
  func.func @main(%lhs: !shape.shape, %rhs: !shape.shape) -> !shape.shape {
    %result = shape.concat %lhs, %rhs : !shape.shape, !shape.shape -> !shape.shape
    return %result : !shape.shape
  }
}