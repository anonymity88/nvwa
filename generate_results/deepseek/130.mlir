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
  
  func.func @main(%input_asin: f64, %input_cosh: f64, %input_erf: f64) -> (f64, f64, f64) {
    %asin_result = call @compute_asin(%input_asin) : (f64) -> f64
    %cosh_result = call @compute_cosh(%input_cosh) : (f64) -> f64
    %erf_result = call @compute_erf(%input_erf) : (f64) -> f64
    
    return %asin_result, %cosh_result, %erf_result : f64, f64, f64
  }
}