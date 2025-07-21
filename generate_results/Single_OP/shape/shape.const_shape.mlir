module {
  func.func @main() -> !shape.shape {
    %result1 = shape.const_shape [] : !shape.shape
    %result2 = shape.const_shape [1, 2, 3] : !shape.shape
    %result3 = shape.const_shape [4, 5, 6] : tensor<3xindex>
    return %result1 : !shape.shape
  }
}