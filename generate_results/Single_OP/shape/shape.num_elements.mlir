module {
  func.func @main(%arg0: !shape.shape) -> !shape.size {
    %result = shape.num_elements %arg0 : !shape.shape -> !shape.size
    return %result : !shape.size
  }
}