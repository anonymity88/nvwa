module {
  func.func @main(%arg0: tensor<4xf32>) -> tensor<4xi32> {
    %0 = arith.fptoui %arg0 : tensor<4xf32> to tensor<4xi32>
    return %0 : tensor<4xi32>
  }
}