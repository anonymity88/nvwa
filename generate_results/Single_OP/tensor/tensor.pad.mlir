module {
  func.func @main(%arg0: tensor<10xi32>) -> tensor<18xi32> {
    %c0_i32 = arith.constant 0 : i32
    %padded = tensor.pad %arg0 low[3] high[5] {
      ^bb0(%arg1: index):
        tensor.yield %c0_i32 : i32
    } : tensor<10xi32> to tensor<18xi32>
    return %padded : tensor<18xi32>
  }
}