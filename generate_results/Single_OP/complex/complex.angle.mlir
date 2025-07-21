module {
  func.func @main(%arg0: complex<f32>) -> f32 {
    %0 = complex.angle %arg0 : complex<f32>
    return %0 : f32
  }
}