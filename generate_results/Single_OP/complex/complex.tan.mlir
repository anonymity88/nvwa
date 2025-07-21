module {
  func.func @main(%arg0: complex<f32>) -> complex<f32> {
    %0 = complex.tan %arg0 : complex<f32>
    return %0 : complex<f32>
  }
}