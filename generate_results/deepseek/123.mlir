module {
  func.func @compute_exp2(%b: f64) -> f64 {
    %a = math.exp2 %b : f64
    return %a : f64
  }
  
  func.func @compute_erf(%b: f64) -> f64 {
    %a = math.erf %b : f64
    return %a : f64
  }
  
  func.func @compute_roundeven(%b: f64) -> f64 {
    %a = math.roundeven %b : f64
    return %a : f64
  }
  
  func.func @main(%input_exp2: f64, %input_erf: f64, %input_roundeven: f64) -> (f64, f64, f64) {
    %exp2_result = call @compute_exp2(%input_exp2) : (f64) -> f64
    %erf_result = call @compute_erf(%input_erf) : (f64) -> f64
    %roundeven_result = call @compute_roundeven(%input_roundeven) : (f64) -> f64
    return %exp2_result, %erf_result, %roundeven_result : f64, f64, f64
  }
}