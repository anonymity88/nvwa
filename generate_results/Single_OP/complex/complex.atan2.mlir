module {
  func.func @main(%lhs: complex<f32>, %rhs: complex<f32>) -> complex<f32> {
    %0 = complex.atan2 %lhs, %rhs : complex<f32>
    return %0 : complex<f32>
  }
}