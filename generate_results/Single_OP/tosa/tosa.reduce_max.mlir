func.func @reduce_max_example() -> tensor<1x3xi32> {
  %const = "tosa.const"() <{value = dense<[[1, 3, 5], [2, 4, 6]]> : tensor<2x3xi32>}> : () -> tensor<2x3xi32>
  %0 = tosa.reduce_max %const {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
  return %0 : tensor<1x3xi32>
}