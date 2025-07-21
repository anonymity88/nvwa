module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> f32 {
    // Compute square root of first argument
    %sqrt = complex.sqrt %arg0 : complex<f32>
    
    // Compute atan2 of both arguments
    %atan2 = complex.atan2 %arg0, %arg1 : complex<f32>
    
    // Compute imaginary part of first argument
    %im = complex.im %arg0 : complex<f32>
    
    // Compute imaginary part of atan2 result
    %im_atan2 = complex.im %atan2 : complex<f32>
    
    // Add the two imaginary parts
    %result = arith.addf %im, %im_atan2 : f32
    
    return %result : f32
  }
}