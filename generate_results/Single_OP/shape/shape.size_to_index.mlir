module {
  func.func @main(%arg0: !shape.size) -> index {
    %result = "shape.size_to_index"(%arg0) : (!shape.size) -> index
    return %result : index
  }
}