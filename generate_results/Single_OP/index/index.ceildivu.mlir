module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.ceildivu %a, %b
    return %c : index
  }
}