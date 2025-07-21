module {
  func.func @main(%arg0: complex<f32>) -> f32 {
    %negated = complex.neg %arg0 : complex<f32>
    %sine = complex.sin %arg0 : complex<f32>
    %angle = complex.angle %arg0 : complex<f32>
    
    // Using the angle as the return value while demonstrating all operations
    return %angle : f32
  }
}