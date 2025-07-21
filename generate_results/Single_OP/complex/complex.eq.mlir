module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> i1 {
    %0 = complex.eq %arg0, %arg1 : complex<f32>
    return %0 : i1
  }
}