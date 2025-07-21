module {
  func.func @reduce_prod_example() -> tensor<1x3xi32> {
    %input_tensor = "tosa.const"() <{value = dense<[[1, 2, 3], [4, 5, 6]]> : tensor<2x3xi32>}> : () -> tensor<2x3xi32>
    %result = tosa.reduce_prod %input_tensor {axis = 0 : i32} : (tensor<2x3xi32>) -> tensor<1x3xi32>
    return %result : tensor<1x3xi32>
  }
}