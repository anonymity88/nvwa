module {
  func.func @main() -> f64 {
    // Define two floating-point values
    %b = arith.constant 3.5 : f64
    %c = arith.constant -2.1 : f64

    // Scalar floating-point maximum using arith.maxnumf
    %result = arith.maxnumf %b, %c : f64

    // Return the result
    return %result : f64
  }
}