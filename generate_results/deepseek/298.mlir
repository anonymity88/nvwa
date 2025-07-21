module {
  func.func @main(%lhs: complex<f32>, %rhs: complex<f32>) -> (f32, complex<f32>) {
    // Original main function operations
    %rsqrt = complex.rsqrt %lhs : complex<f32>
    %div = complex.div %rhs, %rsqrt : complex<f32>
    %im = complex.im %div : complex<f32>
    
    // Call the complex_tanh function with the divided result
    %tanh_result = call @complex_tanh(%div) : (complex<f32>) -> complex<f32>
    
    return %im, %tanh_result : f32, complex<f32>
  }
  
  func.func @complex_tanh(%arg: complex<f32>) -> complex<f32> {
    %tanh = complex.tanh %arg : complex<f32>
    return %tanh : complex<f32>
  }
}