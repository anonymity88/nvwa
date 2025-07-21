module {
  func.func @compute_sin(%b: f64) -> f64 {
    %a = math.sin %b : f64
    return %a : f64
  }

  func.func @compute_asin(%b: f64) -> f64 {
    %a = math.asin %b : f64
    return %a : f64
  }

  func.func @compute_log2(%x: f64) -> f64 {
    %y = math.log2 %x : f64
    return %y : f64
  }

  func.func @main(%input_sin: f64, %input_asin: f64, %input_log: f64) -> (f64, f64, f64) {
    // Compute all three operations
    %sin_result = call @compute_sin(%input_sin) : (f64) -> f64
    %asin_result = call @compute_asin(%input_asin) : (f64) -> f64
    %log_result = call @compute_log2(%input_log) : (f64) -> f64
    
    // Return all three results
    return %sin_result, %asin_result, %log_result : f64, f64, f64
  }
}