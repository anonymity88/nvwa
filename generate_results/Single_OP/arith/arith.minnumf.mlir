module {
  func.func @main(%b: f64, %c: f64) -> f64 {
    // Scalar floating-point minimum.
    %result = arith.minnumf %b, %c : f64
    return %result : f64
  }
}