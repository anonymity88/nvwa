module {
  func.func @main(%arg0: index, %arg1: index) -> !shape.shape {
    %result = shape.from_extents %arg0 : index
    return %result : !shape.shape
  }
}