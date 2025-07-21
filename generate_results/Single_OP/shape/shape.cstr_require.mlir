module {
  func.func @main(%pred: i1) -> !shape.witness {
    %result = shape.cstr_require %pred, "Assertion message"
    return %result : !shape.witness
  }
}