module {
  func.func @main(%arg0: complex<f32>, %arg1: complex<f32>) -> complex<f32> {
    // First perform negation on the first argument
    %negated = complex.neg %arg0 : complex<f32>
    
    // Then multiply the negated value with the second argument
    %product = complex.mul %negated, %arg1 : complex<f32>
    
    // Finally divide the product by the original first argument
    %result = complex.div %product, %arg0 : complex<f32>
    
    // Return the final result
    return %result : complex<f32>
  }
}