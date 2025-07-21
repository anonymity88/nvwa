module {
  func.func @main(%input1: tensor<12x6xf32>, %input2: tensor<12x6xf32>) -> (tensor<12x6xf32>) {
    %output = "tosa.add"(%input1, %input2) : (tensor<12x6xf32>, tensor<12x6xf32>) -> tensor<12x6xf32>
    return %output : tensor<12x6xf32>
  }
}