module {
  func.func @main(%real: f32, %imaginary: f32) -> complex<f32> {
    %0 = complex.create %real, %imaginary : complex<f32>
    return %0 : complex<f32>
  }
}