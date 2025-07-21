module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.add %a, %b
    return %c : index
  }
}