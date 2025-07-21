module {
  func.func @main(%arg0: complex<f32>) -> complex<f32> {
    %0 = complex.sign %arg0 : complex<f32>
    return %0 : complex<f32>
  }
}