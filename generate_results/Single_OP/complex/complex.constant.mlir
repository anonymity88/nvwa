module {
  func.func @main() -> complex<f64> {
    %0 = complex.constant [0.1, -1.0] : complex<f64>
    return %0 : complex<f64>
  }
}