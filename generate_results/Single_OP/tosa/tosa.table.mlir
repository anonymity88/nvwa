module {
  func.func @main(%input: tensor<4xf32>, %table: tensor<1xf32>) -> (tensor<4xf32>) {
    %output = "tosa.table"(%input, %table) : (tensor<4xf32>, tensor<1xf32>) -> tensor<4xf32>
    return %output : tensor<4xf32>
  }
}