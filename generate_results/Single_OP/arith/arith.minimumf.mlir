module {
  func.func @main(%b: f64, %c: f64) -> f64 {
    %result = arith.minimumf %b, %c : f64
    return %result : f64
  }
}