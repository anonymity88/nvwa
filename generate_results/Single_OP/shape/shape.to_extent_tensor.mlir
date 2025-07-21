module {
  func.func @main(%arg0: !shape.shape) -> tensor<1xindex> {
    %result = shape.to_extent_tensor %arg0 : !shape.shape -> tensor<1xindex>
    return %result : tensor<1xindex>
  }
}