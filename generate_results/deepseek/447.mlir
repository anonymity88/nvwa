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
  
  func.func @atan_fold_vec() -> (vector<4xf32>) {
    %v1 = arith.constant dense<[0.0, 1.0, 0.0, 1.0]> : vector<4xf32>
    %0 = math.atan %v1 : vector<4xf32>
    return %0 : vector<4xf32>
  }
  
  func.func @main(%input_exp2: f64, %input_erf: f64, %input_roundeven: f64) -> (f64, f64, f64, vector<4xf32>) {
    %exp2_result = call @compute_exp2(%input_exp2) : (f64) -> f64
    %erf_result = call @compute_erf(%input_erf) : (f64) -> f64
    %roundeven_result = call @compute_roundeven(%input_roundeven) : (f64) -> f64
    %atan_result = call @atan_fold_vec() : () -> vector<4xf32>
    return %exp2_result, %erf_result, %roundeven_result, %atan_result : f64, f64, f64, vector<4xf32>
  }
}