module {
  func.func @main(%input: tensor<?x?xf32>) -> (tensor<?x?xf32>) {
    %output = "tosa.sin"(%input) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    return %output : tensor<?x?xf32>
  }
}