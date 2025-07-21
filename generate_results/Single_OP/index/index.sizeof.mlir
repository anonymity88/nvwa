module {
  func.func @main() -> index {
    %size_in_bits = index.sizeof
    return %size_in_bits : index
  }
}