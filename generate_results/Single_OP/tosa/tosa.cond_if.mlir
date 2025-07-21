module {
  func.func @main(%cond: tensor<i1>, %input1: tensor<4xf32>, %input2: tensor<4xf32>) -> tensor<4xf32> {
    %0 = "tosa.cond_if"(%cond) ({
        ^bb0():
          %1 = "tosa.add"(%input1, %input2) : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
          tosa.yield %1 : tensor<4xf32>
      }, {
        ^bb0():
          %2 = "tosa.mul"(%input1, %input2) { shift = 0 : i8 } : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
          tosa.yield %2 : tensor<4xf32>
      }) : (tensor<i1>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
  }
}