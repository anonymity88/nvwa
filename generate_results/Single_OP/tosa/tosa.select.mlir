module {
  func.func @main(%pred: tensor<4xi1>, %on_true: tensor<4xf32>, %on_false: tensor<4xf32>) -> (tensor<4xf32>) {
    %0 = "tosa.select"(%pred, %on_true, %on_false) : (tensor<4xi1>, tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
  }
}