module {
  func.func @main(%a: index, %b: index, %c: index, %d: index, %e: index, %f: index) -> tensor<2x3xindex> {
    %result = tensor.from_elements %a, %b, %c, %d, %e, %f : tensor<2x3xindex>
    return %result : tensor<2x3xindex>
  }
}