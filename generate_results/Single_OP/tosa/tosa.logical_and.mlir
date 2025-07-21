module {
  func.func @main(%input1: tensor<?x?xi1>, %input2: tensor<?x?xi1>) -> tensor<?x?xi1> {
    %result = "tosa.logical_and"(%input1, %input2) : (tensor<?x?xi1>, tensor<?x?xi1>) -> tensor<?x?xi1>
    return %result : tensor<?x?xi1>
  }
}