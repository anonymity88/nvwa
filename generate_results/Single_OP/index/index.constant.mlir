module {
  func.func @main() -> index {
    %c = index.constant 42
    return %c : index
  }
}