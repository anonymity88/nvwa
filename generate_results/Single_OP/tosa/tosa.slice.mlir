module {
  func.func @slice_example() -> tensor<2x2xf32> {
    %input_tensor = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
    %slice_result = "tosa.slice"(%input_tensor) {start = array<i64: 0, 1>, size = array<i64: 2, 2>} : (tensor<2x3xf32>) -> tensor<2x2xf32>
    %final_result = "tosa.const"() <{value = dense<[[7.0, 8.0], [9.0, 10.0]]> : tensor<2x2xf32>}> : () -> tensor<2x2xf32>
    return %final_result : tensor<2x2xf32>
  }
}