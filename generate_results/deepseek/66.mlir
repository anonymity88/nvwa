module {
  func.func @main(%lhs: complex<f32>, %rhs: complex<f32>) -> f32 {
    // First compute the reciprocal square root of lhs
    %rsqrt = complex.rsqrt %lhs : complex<f32>
    
    // Then divide rhs by the rsqrt result
    %div = complex.div %rhs, %rsqrt : complex<f32>
    
    // Finally get the imaginary part of the division result
    %im = complex.im %div : complex<f32>
    
    // Return the imaginary part
    return %im : f32
  }
}