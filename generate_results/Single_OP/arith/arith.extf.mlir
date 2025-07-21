module {
  func.func @main() -> f64 {
    %0 = arith.constant 1.0 : f32  // Source floating-point value
    %1 = arith.extf %0 : f32 to f64  // Extending to a wider floating-point (double)
    return %1 : f64
  }
}