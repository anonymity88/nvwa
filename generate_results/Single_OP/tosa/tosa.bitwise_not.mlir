module {
  func.func @main(%input1: tensor<?x?xi32>) -> (tensor<?x?xi32>) {
    %output = "tosa.bitwise_not"(%input1) : (tensor<?x?xi32>) -> tensor<?x?xi32>
    return %output : tensor<?x?xi32>
  }
}