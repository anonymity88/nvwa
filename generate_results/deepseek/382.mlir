module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> complex<f32> {
    %0 = complex.sign %arg0 : complex<f32>
    %1 = complex.expm1 %arg0 : complex<f32>
    %2 = complex.add %arg0, %arg1 : complex<f32>
    
    // Call the complex_sqrt function with the addition result
    %sqrt_result = call @complex_sqrt(%2) : (complex<f32>) -> complex<f32>
    
    return %sqrt_result : complex<f32>
  }
  
  func.func @complex_sqrt(%arg: complex<f32>) -> complex<f32> {
    %sqrt = complex.sqrt %arg : complex<f32>
    return %sqrt : complex<f32>
  }
}