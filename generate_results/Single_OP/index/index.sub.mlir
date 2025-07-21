module {
  func.func @main(%a: index, %b: index) -> index {
    %result = index.sub %a, %b
    return %result : index
  }
}