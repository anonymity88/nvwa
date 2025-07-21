module {
  func.func @reduce_sum_example() -> tensor<1x3xi32> {
    %const = "tosa.const"() <{value = dense<[[1, 2, 3], [4, 5, 6]]> : tensor<2x3xi32>}> : () -> tensor<2x3xi32>
    %0 = tosa.reduce_sum %const {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
    return %0 : tensor<1x3xi32>
  }
}