module {
  func.func @main() -> !shape.size {
    %result = "shape.const_size"() {value = 10 : index} : () -> !shape.size
    return %result : !shape.size
  }
}