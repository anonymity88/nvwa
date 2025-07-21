module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.or %a, %b
    return %c : index
  }
}