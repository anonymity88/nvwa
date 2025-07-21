module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>) {
    // Original main function operations
    %negated = complex.neg %arg0 : complex<f32>
    %product = complex.mul %negated, %arg1 : complex<f32>
    %result = complex.div %product, %arg0 : complex<f32>
    
    // Call to complex_conj_conj function
    %conj_result = call @complex_conj_conj() : () -> complex<f32>
    
    return %result, %conj_result : complex<f32>, complex<f32>
  }

  func.func @complex_conj_conj() -> complex<f32> {
    %complex1 = complex.constant [1.0 : f32, 0.0 : f32] : complex<f32>
    %conj1 = complex.conj %complex1 : complex<f32>
    %conj2 = complex.conj %conj1 : complex<f32>
    return %conj2 : complex<f32>
  }

  // Additional complex operations for demonstration
  func.func @complex_ops(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>) {
    %sum = complex.add %arg0, %arg1 : complex<f32>
    %diff = complex.sub %arg0, %arg1 : complex<f32>
    return %sum, %diff : complex<f32>, complex<f32>
  }

  // Extended main function that calls all operations
  func.func @main_extended(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>, complex<f32>) {
    // Call original main
    %main_result, %conj_result = call @main(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (complex<f32>, complex<f32>)
    
    // Call complex ops
    %sum_result, %diff_result = call @complex_ops(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (complex<f32>, complex<f32>)
    
    return %main_result, %conj_result, %sum_result, %diff_result : complex<f32>, complex<f32>, complex<f32>, complex<f32>
  }
}