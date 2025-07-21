module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> complex<f32> {
    // Call complex_create to create new complex numbers
    %real_part = arith.constant 1.0 : f32
    %imag_part = arith.constant 2.0 : f32
    %created = call @complex_create(%real_part, %imag_part) : (f32, f32) -> complex<f32>
    
    // Perform various complex operations
    %sign = complex.sign %arg0 : complex<f32>
    %rsqrt = complex.rsqrt %arg0 : complex<f32>
    %atan2 = complex.atan2 %arg0, %arg1 : complex<f32>
    
    // Combine results
    %sum1 = complex.add %sign, %rsqrt : complex<f32>
    %final_result = complex.add %sum1, %atan2 : complex<f32>
    
    return %final_result : complex<f32>
  }

  func.func @complex_create(%real: f32, %imag: f32) -> complex<f32> {
    %cplx = complex.create %real, %imag : complex<f32>
    return %cplx : complex<f32>
  }

  func.func @complex_ops(%arg0: complex<f32>, %arg1: complex<f32>) -> complex<f32> {
    // Additional complex operations
    %sum = complex.add %arg0, %arg1 : complex<f32>
    %prod = complex.mul %arg0, %arg1 : complex<f32>
    %diff = complex.sub %arg0, %arg1 : complex<f32>
    %div = complex.div %arg0, %arg1 : complex<f32>
    
    // Combine results
    %result1 = complex.add %sum, %prod : complex<f32>
    %result2 = complex.add %diff, %div : complex<f32>
    %final = complex.add %result1, %result2 : complex<f32>
    
    return %final : complex<f32>
  }

  // Main function that calls all operations
  func.func @main_complex(%arg0: complex<f32>, %arg1: complex<f32>) -> complex<f32> {
    %main_result = call @main(%arg0, %arg1) : (complex<f32>, complex<f32>) -> complex<f32>
    %ops_result = call @complex_ops(%arg0, %arg1) : (complex<f32>, complex<f32>) -> complex<f32>
    %final = complex.add %main_result, %ops_result : complex<f32>
    return %final : complex<f32>
  }
}