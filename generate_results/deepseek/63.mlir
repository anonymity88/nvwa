module {
  func.func @main(%arg0: complex<f32>) -> complex<f32> {
    %0 = complex.sqrt %arg0 : complex<f32>
    %1 = complex.rsqrt %arg0 : complex<f32>
    %2 = complex.cos %arg0 : complex<f32>
    // For demonstration purposes, returning the cosine result
    return %2 : complex<f32>
  }
}