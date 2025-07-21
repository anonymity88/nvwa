module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.mul %a, %b
    return %c : index
  }
}