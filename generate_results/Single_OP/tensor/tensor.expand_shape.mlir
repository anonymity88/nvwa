module {
  func.func @main(%a: tensor<?x32xf32>, %sz0: index, %sz1: index) -> tensor<?x?x32xf32> {
    %b = tensor.expand_shape %a [[0, 1], [2]] output_shape [%sz0, %sz1, 32] 
      : tensor<?x32xf32> into tensor<?x?x32xf32>
    return %b : tensor<?x?x32xf32>
  }
}