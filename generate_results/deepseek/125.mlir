module {
  func.func @compute_ceil(%b: f64) -> f64 {
    %a = math.ceil %b : f64
    return %a : f64
  }

  func.func @compute_pow(%b: f64, %c: f64) -> f64 {
    %a = math.powf %b, %c : f64
    return %a : f64
  }

  func.func @compute_trunc(%b: f64) -> f64 {
    %a = math.trunc %b : f64
    return %a : f64
  }

  func.func @main(%input_ceil: f64, %input_pow_base: f64, %input_pow_exp: f64, %input_trunc: f64) -> (f64, f64, f64) {
    // Compute ceiling
    %ceil_result = call @compute_ceil(%input_ceil) : (f64) -> f64
    
    // Compute power
    %pow_result = call @compute_pow(%input_pow_base, %input_pow_exp) : (f64, f64) -> f64
    
    // Compute truncation
    %trunc_result = call @compute_trunc(%input_trunc) : (f64) -> f64
    
    return %ceil_result, %pow_result, %trunc_result : f64, f64, f64
  }
}