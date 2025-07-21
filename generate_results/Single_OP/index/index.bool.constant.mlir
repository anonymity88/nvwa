module {
  func.func @main() -> (i1) {
    %bool_const = index.bool.constant true
    return %bool_const : i1
  }
}