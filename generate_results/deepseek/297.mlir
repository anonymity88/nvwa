module {
  func.func @compute_powf(%base: f64, %exponent: f64) -> f64 {
    %result = math.powf %base, %exponent : f64
    return %result : f64
  }

  func.func @compute_fma(%a: f64, %b: f64, %c: f64) -> f64 {
    %result = math.fma %a, %b, %c : f64
    return %result : f64
  }

  func.func @compute_log10(%x: f64) -> f64 {
    %result = math.log10 %x : f64
    return %result : f64
  }

  func.func @tan_fold() -> f32 {
    %c = arith.constant 1.0 : f32
    %r = math.tan %c : f32
    return %r : f32
  }

  func.func @main(%pow_base: f64, %pow_exp: f64, 
                 %fma_a: f64, %fma_b: f64, %fma_c: f64,
                 %log_input: f64) -> (f64, f64, f64, f32) {
    %pow_result = call @compute_powf(%pow_base, %pow_exp) : (f64, f64) -> f64
    %fma_result = call @compute_fma(%fma_a, %fma_b, %fma_c) : (f64, f64, f64) -> f64
    %log_result = call @compute_log10(%log_input) : (f64) -> f64
    %tan_result = call @tan_fold() : () -> f32
    
    return %pow_result, %fma_result, %log_result, %tan_result : f64, f64, f64, f32
  }
}