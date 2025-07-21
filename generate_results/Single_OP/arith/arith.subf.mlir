module {
  func.func @main() -> f64 {
    %b = arith.constant 5.0 : f64
    %c = arith.constant 3.0 : f64
    %result = arith.subf %b, %c : f64
    return %result : f64
  }
}