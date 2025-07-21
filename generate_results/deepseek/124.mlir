module {
  func.func @compute_sinh(%b: f64) -> f64 {
    %a = math.sinh %b : f64
    return %a : f64
  }

  func.func @compute_roundeven(%b: f64) -> f64 {
    %a = math.roundeven %b : f64
    return %a : f64
  }

  func.func @compute_asinh(%b: f64) -> f64 {
    %a = math.asinh %b : f64
    return %a : f64
  }

  func.func @main(%input_sinh: f64, %input_round: f64, %input_asinh: f64) -> (f64, f64, f64) {
    %sinh_result = call @compute_sinh(%input_sinh) : (f64) -> f64
    %round_result = call @compute_roundeven(%input_round) : (f64) -> f64
    %asinh_result = call @compute_asinh(%input_asinh) : (f64) -> f64
    
    return %sinh_result, %round_result, %asinh_result : f64, f64, f64
  }
}