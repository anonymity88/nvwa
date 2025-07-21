module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.floordivs %a, %b
    return %c : index
  }
}