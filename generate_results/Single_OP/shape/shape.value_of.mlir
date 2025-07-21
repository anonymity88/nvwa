module {
  func.func @main(%arg0: !shape.value_shape<tensor<2x3xf32>>) -> tensor<2x3xf32> {
    %result = shape.value_of %arg0 : tensor<2x3xf32>
    return %result : tensor<2x3xf32>
  }
}