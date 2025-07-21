module {
  func.func @main(%arg0: complex<f32>) -> (f32, complex<f32>) {
    // Operations from first IR
    %negated = complex.neg %arg0 : complex<f32>
    %sine = complex.sin %arg0 : complex<f32>
    %angle = complex.angle %arg0 : complex<f32>
    
    // Call to complex_exp_log function
    %exp_log_result = call @complex_exp_log() : () -> complex<f32>
    
    // Create new complex number from angle result
    %zero = arith.constant 0.0 : f32
    %angle_complex = complex.create %angle, %zero : complex<f32>
    
    // Combine results
    %combined = complex.add %exp_log_result, %angle_complex : complex<f32>
    
    return %angle, %combined : f32, complex<f32>
  }

  func.func @complex_exp_log() -> complex<f32> {
    %complex1 = complex.constant [1.0 : f32, 0.0 : f32] : complex<f32>
    %log = complex.log %complex1 : complex<f32>
    %exp = complex.exp %log : complex<f32>
    return %exp : complex<f32>
  }

  // Additional complex operations that can be called
  func.func @complex_ops(%arg0: complex<f32>) -> (complex<f32>, f32) {
    %cos = complex.cos %arg0 : complex<f32>
    %abs = complex.abs %arg0 : complex<f32>
    return %cos, %abs : complex<f32>, f32
  }

  // Main entry point that calls all functions
  func.func @entry_point(%arg0: complex<f32>) -> (f32, complex<f32>, complex<f32>, f32) {
    // Call main function
    %angle_result, %combined_result = call @main(%arg0) : (complex<f32>) -> (f32, complex<f32>)
    
    // Call complex_ops function
    %cos_result, %abs_result = call @complex_ops(%arg0) : (complex<f32>) -> (complex<f32>, f32)
    
    return %angle_result, %combined_result, %cos_result, %abs_result : f32, complex<f32>, complex<f32>, f32
  }
}