module {
  func.func @main(%input1: tensor<?x?xf32>) -> (tensor<?x?xf32>) {
    %output = "tosa.abs"(%input1) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    return %output : tensor<?x?xf32>
  }
}