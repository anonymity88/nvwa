func.func @reshape_example() -> tensor<3x2xf32> {
  %input_tensor = "tosa.const"() <{value = dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>}> : () -> tensor<2x3xf32>
  %reshaped_tensor = "tosa.reshape"(%input_tensor) {new_shape = array<i64: 3, 2>} : (tensor<2x3xf32>) -> tensor<3x2xf32>
  return %reshaped_tensor : tensor<3x2xf32>
}