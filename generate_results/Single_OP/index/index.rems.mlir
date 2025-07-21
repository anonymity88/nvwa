module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.rems %a, %b
    return %c : index
  }
}