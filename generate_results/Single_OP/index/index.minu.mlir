module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.minu %a, %b
    return %c : index
  }
}