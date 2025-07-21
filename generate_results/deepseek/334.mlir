module {
  func.func @compute_ipowi(%base: i32, %power: i32) -> i32 {
    %result = math.ipowi %base, %power : i32
    return %result : i32
  }

  func.func @compute_ceil(%input: f64) -> f64 {
    %result = math.ceil %input : f64
    return %result : f64
  }

  func.func @compute_tan(%angle: f64) -> f64 {
    %result = math.tan %angle : f64
    return %result : f64
  }

  func.func @roundf_func(%a: f32) -> f32 {
    %ret = math.round %a : f32
    return %ret : f32
  }

  func.func @main(%ipowi_base: i32, %ipowi_power: i32, %ceil_input: f64, %tan_input: f64, %round_input: f32) -> (i32, f64, f64, f32) {
    %power_result = call @compute_ipowi(%ipowi_base, %ipowi_power) : (i32, i32) -> i32
    
    %ceil_result = call @compute_ceil(%ceil_input) : (f64) -> f64
    
    %tan_result = call @compute_tan(%tan_input) : (f64) -> f64
    
    %round_result = call @roundf_func(%round_input) : (f32) -> f32
    
    return %power_result, %ceil_result, %tan_result, %round_result : i32, f64, f64, f32
  }
}