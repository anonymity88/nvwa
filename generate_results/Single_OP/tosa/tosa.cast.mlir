module {
  func.func @main(%input: tensor<4xi8>) -> (tensor<4xi16>) {
    %output = "tosa.cast"(%input) : (tensor<4xi8>) -> tensor<4xi16>
    return %output : tensor<4xi16>
  }
}