module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.shrs %a, %b
    return %c : index
  }
}