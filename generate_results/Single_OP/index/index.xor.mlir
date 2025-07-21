module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.xor %a, %b
    return %c : index
  }
}