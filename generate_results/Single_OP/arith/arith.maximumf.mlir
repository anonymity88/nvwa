module {
  func.func @main() {
    %b = arith.constant 3.5 : f64
    %c = arith.constant 2.1 : f64
    %result = arith.maximumf %b, %c : f64
    return
  }
}