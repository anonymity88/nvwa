module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, f32, i1, i1) {
    // Compute tangent of complex number
    %0 = complex.tan %arg0 : complex<f32>
    
    // Get real part of complex number
    %1 = complex.re %arg0 : complex<f32>
    
    // Direct inequality comparison
    %2 = complex.neq %arg0, %arg1 : complex<f32>
    
    // Call complex_neq function for same comparison
    %3 = call @complex_neq(%arg0, %arg1) : (complex<f32>, complex<f32>) -> i1
    
    return %0, %1, %2, %3 : complex<f32>, f32, i1, i1
  }
  
  func.func @complex_neq(%lhs: complex<f32>, %rhs: complex<f32>) -> i1 {
    %neq = complex.neq %lhs, %rhs : complex<f32>
    return %neq : i1
  }
  
  // Additional complex operations for demonstration
  func.func @complex_ops(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>) {
    // Addition
    %sum = complex.add %arg0, %arg1 : complex<f32>
    
    // Multiplication
    %prod = complex.mul %arg0, %arg1 : complex<f32>
    
    // Division
    %quot = complex.div %arg0, %arg1 : complex<f32>
    
    return %sum, %prod, %quot : complex<f32>, complex<f32>, complex<f32>
  }
  
  // Function demonstrating calling relationships
  func.func @main_with_calls(%arg0: complex<f32>, %arg1: complex<f32>) -> (complex<f32>, f32, i1, complex<f32>) {
    // Call original main function
    %tan, %real, %neq1, %neq2 = call @main(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (complex<f32>, f32, i1, i1)
    
    // Call complex operations
    %sum, %prod, %quot = call @complex_ops(%arg0, %arg1) : (complex<f32>, complex<f32>) -> (complex<f32>, complex<f32>, complex<f32>)
    
    return %tan, %real, %neq1, %sum : complex<f32>, f32, i1, complex<f32>
  }
}