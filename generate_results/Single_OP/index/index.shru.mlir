module {
  func.func @main(%a: index, %b: index) -> index {
    %result = index.shru %a, %b
    return %result : index
  }
}