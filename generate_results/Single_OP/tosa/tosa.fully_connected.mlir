module {
  func.func @main(%input: tensor<?x?xf32>, %weight: tensor<?x?xf32>, %bias: tensor<?xf32>) -> (tensor<?x?xf32>) {
    %output = "tosa.fully_connected"(%input, %weight, %bias) : (tensor<?x?xf32>, tensor<?x?xf32>, tensor<?xf32>) -> tensor<?x?xf32>
    return %output : tensor<?x?xf32>
  }
}