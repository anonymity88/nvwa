module {
  func.func @main(%a: index, %b: index) -> index {
    %result = index.divu %a, %b
    return %result : index
  }
}