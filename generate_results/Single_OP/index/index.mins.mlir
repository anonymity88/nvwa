module {
  func.func @main(%a: index, %b: index) -> index {
    %min_value = index.mins %a, %b
    return %min_value : index
  }
}