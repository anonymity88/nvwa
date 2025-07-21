module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, f32, i1) {
    // Compute tangent of first complex argument
    %0 = complex.tan %arg0 : complex<f32>
    
    // Extract real part of first complex argument
    %1 = complex.re %arg0 : complex<f32>
    
    // Compare two complex numbers for inequality
    %2 = complex.neq %arg0, %arg1 : complex<f32>
    
    // Return all three results as a tuple
    return %0, %1, %2 : complex<f32>, f32, i1
  }
}