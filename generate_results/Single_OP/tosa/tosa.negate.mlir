module {
  func.func @main(%input1: tensor<?x?xf32>) -> (tensor<?x?xf32>) {
    %0 = "tosa.negate"(%input1) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    return %0 : tensor<?x?xf32>
  }
}