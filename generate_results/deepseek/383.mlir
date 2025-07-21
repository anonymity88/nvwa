module {
  func.func @main(%arg0: complex<f32>) -> (complex<f32>, complex<f32>) {
    %0 = complex.sqrt %arg0 : complex<f32>
    %1 = complex.rsqrt %arg0 : complex<f32>
    %2 = complex.cos %arg0 : complex<f32>
    %expm1_result = call @complex_expm1(%arg0) : (complex<f32>) -> complex<f32>
    return %2, %expm1_result : complex<f32>, complex<f32>
  }

  func.func @complex_expm1(%arg: complex<f32>) -> complex<f32> {
    %expm1 = complex.expm1 %arg : complex<f32>
    return %expm1 : complex<f32>
  }

  // Additional complex operations for demonstration
  func.func @complex_operations(%arg0: complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>) {
    %sqrt = complex.sqrt %arg0 : complex<f32>
    %rsqrt = complex.rsqrt %arg0 : complex<f32>
    %cos = complex.cos %arg0 : complex<f32>
    return %sqrt, %rsqrt, %cos : complex<f32>, complex<f32>, complex<f32>
  }

  // Function that calls both main and complex_operations
  func.func @combined_operations(%arg0: complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>, complex<f32>) {
    %main_result1, %main_result2 = call @main(%arg0) : (complex<f32>) -> (complex<f32>, complex<f32>)
    %op1, %op2, %op3 = call @complex_operations(%arg0) : (complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>)
    return %main_result1, %main_result2, %op1, %op2 : complex<f32>, complex<f32>, complex<f32>, complex<f32>
  }
}