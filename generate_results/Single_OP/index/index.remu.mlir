module {
  func.func @main(%a: index, %b: index) -> index {
    %result = index.remu %a, %b
    return %result : index
  }
}