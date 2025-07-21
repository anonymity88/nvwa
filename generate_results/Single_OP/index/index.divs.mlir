module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.divs %a, %b
    return %c : index
  }
}