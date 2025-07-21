module {
  func.func @main(%input1: tensor<?x?xf32>, %perms: tensor<?xi32>) -> (tensor<?x?xf32>) {
    %output = "tosa.transpose"(%input1, %perms) : (tensor<?x?xf32>, tensor<?xi32>) -> tensor<?x?xf32>
    return %output : tensor<?x?xf32>
  }
}