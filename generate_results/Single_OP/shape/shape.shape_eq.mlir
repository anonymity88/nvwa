module {
  func.func @main(%shape1: !shape.shape, %shape2: !shape.shape) -> i1 {
    %result = shape.shape_eq %shape1, %shape2 : !shape.shape, !shape.shape
    return %result : i1
  }
}