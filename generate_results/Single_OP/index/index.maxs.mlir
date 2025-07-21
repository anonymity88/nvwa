module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.maxs %a, %b
    return %c : index
  }
}