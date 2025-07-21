module {
  func.func @reduce_all_example() -> tensor<1x3xi1> {
    %const = "tosa.const"() <{value = dense<[[true, false, true], [false, true, false]]> : tensor<2x3xi1>}> : () -> tensor<2x3xi1>
    %0 = tosa.reduce_all %const {axis = 0 : i32} : (tensor<2x3xi1>) -> tensor<1x3xi1>
    return %0 : tensor<1x3xi1>
  }
}