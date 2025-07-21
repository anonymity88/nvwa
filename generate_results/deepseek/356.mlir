module {
  func.func @compute_asin(%b: f64) -> f64 {
    %a = math.asin %b : f64
    return %a : f64
  }
  
  func.func @compute_cosh(%b: f64) -> f64 {
    %a = math.cosh %b : f64
    return %a : f64
  }
  
  func.func @compute_erf(%b: f64) -> f64 {
    %a = math.erf %b : f64
    return %a : f64
  }
  
  func.func @exp_fold() -> f32 {
    %c = arith.constant 2.0 : f32
    %r = math.exp %c : f32
    return %r : f32
  }
  
  func.func @main(%input_asin: f64, %input_cosh: f64, %input_erf: f64) -> (f64, f64, f64, f32) {
    %asin_result = call @compute_asin(%input_asin) : (f64) -> f64
    %cosh_result = call @compute_cosh(%input_cosh) : (f64) -> f64
    %erf_result = call @compute_erf(%input_erf) : (f64) -> f64
    %exp_result = call @exp_fold() : () -> f32
    
    return %asin_result, %cosh_result, %erf_result, %exp_result : f64, f64, f64, f32
  }
}