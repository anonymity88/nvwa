module {
  func.func @main(%a: index, %b: index) -> i1 {
    %cmp_result = index.cmp slt(%a, %b)
    return %cmp_result : i1
  }
}