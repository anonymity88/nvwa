module {
  func.func @main(%arg0: index, %arg1: index) -> index {
    %result = shape.div %arg0, %arg1 : index, index -> index
    return %result : index
  }
}