module {
  func.func @main(%input1: tensor<?x?x?xi1>, %input2: tensor<?x?x?xi1>) -> (tensor<?x?x?xi1>) {
    %z = "tosa.logical_xor"(%input1, %input2) : (tensor<?x?x?xi1>, tensor<?x?x?xi1>) -> tensor<?x?x?xi1>
    return %z : tensor<?x?x?xi1>
  }
}