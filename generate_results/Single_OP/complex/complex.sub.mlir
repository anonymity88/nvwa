module {
  func.func @main(%lhs: complex<f32>, %rhs: complex<f32>) -> complex<f32> {
    %result = complex.sub %lhs, %rhs : complex<f32>
    return %result : complex<f32>
  }
}