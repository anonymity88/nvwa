module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.maxu %a, %b
    return %c : index
  }
}