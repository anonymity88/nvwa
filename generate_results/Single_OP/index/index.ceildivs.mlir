module {
  func.func @main(%a: index, %b: index) -> index {
    %c = index.ceildivs %a, %b
    return %c : index
  }
}