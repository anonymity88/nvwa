module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> complex<f32> {
    %0 = complex.mul %arg0, %arg1 : complex<f32>
    %1 = complex.div %arg0, %arg1 : complex<f32>
    %2 = complex.expm1 %arg0 : complex<f32>
    
    // Call the conj_caller function with sample complex arguments
    %float_sample = complex.constant [1.0 : f32, -1.0 : f32] : complex<f32>
    %double_sample = complex.constant [2.0 : f64, -2.0 : f64] : complex<f64>
    %conj_results:2 = call @conj_caller(%float_sample, %double_sample) : (complex<f32>, complex<f64>) -> (complex<f32>, complex<f64>)
    
    return %0 : complex<f32>
  }
  
  func.func @conj_caller(%float: complex<f32>, %double: complex<f64>) -> (complex<f32>, complex<f64>) {
    %float_result = complex.conj %float : complex<f32>
    %double_result = complex.conj %double : complex<f64>
    return %float_result, %double_result : complex<f32>, complex<f64>
  }
  
  // Additional complex operations for demonstration
  func.func @complex_ops(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>) {
    %sum = complex.add %arg0, %arg1 : complex<f32>
    %diff = complex.sub %arg0, %arg1 : complex<f32>
    return %sum, %diff : complex<f32>, complex<f32>
  }
  
  // Extended main function that calls all operations
  func.func @main_extended(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>, complex<f64>) {
    // Call original main
    %mul_result = call @main(%arg0, %arg1) : (complex<f32>, complex<f32>) -> complex<f32>
    
    // Call complex ops
    %sum_result, %diff_result = call @complex_ops(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (complex<f32>, complex<f32>) 
    
    // Call conj_caller with different arguments
    %double_sample = complex.constant [3.0 : f64, -3.0 : f64] : complex<f64>
    %conj_results:2 = call @conj_caller(%mul_result, %double_sample) : (complex<f32>, complex<f64>) -> (complex<f32>, complex<f64>)
    
    return %mul_result, %sum_result, %diff_result, %conj_results#1 : complex<f32>, complex<f32>, complex<f32>, complex<f64>
  }
}