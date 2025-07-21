module {
  func.func @main(%arg0: tensor<3x4xf32>) -> tensor<2xindex> {
    %result = shape.shape_of %arg0 : tensor<3x4xf32> -> tensor<2xindex>
    return %result : tensor<2xindex>
  }
}