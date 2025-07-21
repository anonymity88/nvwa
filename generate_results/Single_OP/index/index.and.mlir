module {
  func.func @main(%a: index, %b: index) -> index {
    %result = index.and %a, %b
    return %result : index
  }
}