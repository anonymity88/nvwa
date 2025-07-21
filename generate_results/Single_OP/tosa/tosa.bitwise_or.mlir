module {
  func.func @main(%input1: tensor<?x?xf32>, %input2: tensor<?x?xf32>) -> (tensor<?x?xf32>) {
    %output = "tosa.bitwise_or"(%input1, %input2) : (tensor<?x?xf32>, tensor<?x?xf32>) -> tensor<?x?xf32>
    return %output : tensor<?x?xf32>
  }
}