module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.shl %a, %b
    return %c : index
  }
}