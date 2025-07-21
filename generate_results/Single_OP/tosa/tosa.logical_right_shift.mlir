module {
  func.func @main(%input1: tensor<?x?xi32>, %input2: tensor<?x?xi32>) -> (tensor<?x?xi32>) {
    %output = "tosa.logical_right_shift"(%input1, %input2) : (tensor<?x?xi32>, tensor<?x?xi32>) -> tensor<?x?xi32>
    return %output : tensor<?x?xi32>
  }
}