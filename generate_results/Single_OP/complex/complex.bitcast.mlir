module {
  func.func @main(%arg0: complex<f32>) -> i64 {
    %0 = complex.bitcast %arg0 : complex<f32> to i64
    return %0 : i64
  }
}