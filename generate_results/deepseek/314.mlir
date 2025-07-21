module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> (f32, complex<f32>) {
    // Original main operations
    %sqrt = complex.sqrt %arg0 : complex<f32>
    %atan2 = complex.atan2 %arg0, %arg1 : complex<f32>
    %im = complex.im %arg0 : complex<f32>
    %im_atan2 = complex.im %atan2 : complex<f32>
    %result = arith.addf %im, %im_atan2 : f32
    
    // Call complex_div_with_fmf function
    %div_result = call @complex_div_with_fmf(%arg0, %arg1) : (complex<f32>, complex<f32>) -> complex<f32>
    
    return %result, %div_result : f32, complex<f32>
  }

  func.func @complex_div_with_fmf(%lhs: complex<f32>, %rhs: complex<f32>) -> complex<f32> {
    %div = complex.div %lhs, %rhs fastmath<nsz,arcp> : complex<f32>
    return %div : complex<f32>
  }

  // Additional complex operations for demonstration
  func.func @complex_ops(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>) {
    // Various complex operations
    %sum = complex.add %arg0, %arg1 : complex<f32>
    %diff = complex.sub %arg0, %arg1 : complex<f32>
    %prod = complex.mul %arg0, %arg1 : complex<f32>
    %div = complex.div %arg0, %arg1 : complex<f32>
    %abs = complex.abs %arg0 : complex<f32>
    
    // Combine results
    %final_sum = complex.add %sum, %diff : complex<f32>
    %final_prod = complex.mul %prod, %div : complex<f32>
    
    return %final_sum, %final_prod : complex<f32>, complex<f32>
  }

  // Function demonstrating complex constant creation
  func.func @create_complex_constants() -> (complex<f32>, complex<f64>) {
    %cst_f32 = complex.constant [1.0 : f32, 0.0 : f32] : complex<f32>
    %cst_f64 = complex.constant [0.5 : f64, -0.5 : f64] : complex<f64>
    return %cst_f32, %cst_f64 : complex<f32>, complex<f64>
  }

  // Main function that calls all other functions
  func.func @main_comprehensive(%arg0: complex<f32>, %arg1: complex<f32>) -> (f32, complex<f32>, complex<f32>, complex<f32>, complex<f32>) {
    // Call original main
    %main_result, %div_result = call @main(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (f32, complex<f32>)
    
    // Call complex operations
    %ops_result1, %ops_result2 = call @complex_ops(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (complex<f32>, complex<f32>)
    
    // Call constant creation
    %const_f32, %const_f64 = call @create_complex_constants() : () -> (complex<f32>, complex<f64>)
    
    // Combine results (just using the f32 constant for demonstration)
    %final_result = complex.mul %ops_result1, %const_f32 : complex<f32>
    
    return %main_result, %div_result, %ops_result1, %ops_result2, %final_result : f32, complex<f32>, complex<f32>, complex<f32>, complex<f32>
  }
}