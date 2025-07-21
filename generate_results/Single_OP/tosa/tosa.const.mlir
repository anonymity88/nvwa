module {
  func.func @main() -> tensor<2x3xi32> {
    %out = "tosa.const"() {value = dense<0> : tensor<2x3xi32>} : () -> tensor<2x3xi32>
    return %out : tensor<2x3xi32>
  }
}