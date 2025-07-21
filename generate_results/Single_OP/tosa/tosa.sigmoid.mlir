module {
  func.func @main(%input: tensor<?x?xf32>) -> (tensor<?x?xf32>) {
    %0 = "tosa.sigmoid"(%input) : (tensor<?x?xf32>) -> tensor<?x?xf32>
    return %0 : tensor<?x?xf32>
  }
}