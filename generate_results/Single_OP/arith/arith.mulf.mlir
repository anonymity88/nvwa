module {
  func.func @main() -> f64 {
    %b = arith.constant 3.0 : f64
    %c = arith.constant 4.0 : f64
    %a = arith.mulf %b, %c : f64
    return %a : f64
  }
}