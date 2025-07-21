module {
  func.func @main() -> f64 {
    // Scalar addition.
    %b = arith.constant 3.5 : f64
    %c = arith.constant 2.5 : f64
    %a = arith.addf %b, %c : f64
    return %a : f64
  }
}