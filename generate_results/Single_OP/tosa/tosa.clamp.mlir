module {
  func.func @main(%input: tensor<4xf32>) -> tensor<4xf32> {
    %0 = "tosa.clamp"(%input) {min_int = 0 : i64, max_int = 255 : i64, min_fp = 0.0 : f64, max_fp = 1.0 : f64} : (tensor<4xf32>) -> tensor<4xf32>
    return %0 : tensor<4xf32>
  }
}