module {
  func.func @main(%arg0: index, %arg1: index) -> !shape.size {
    %result = shape.add %arg0, %arg1 : index, index -> !shape.size
    return %result : !shape.size
  }
}