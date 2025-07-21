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

  func.func @main(%ipowi_base: i32, %ipowi_power: i32, %ceil_input: f64, %tan_input: f64) -> (i32, f64, f64) {
    // Compute integer power
    %power_result = call @compute_ipowi(%ipowi_base, %ipowi_power) : (i32, i32) -> i32
    
    // Compute ceiling
    %ceil_result = call @compute_ceil(%ceil_input) : (f64) -> f64
    
    // Compute tangent
    %tan_result = call @compute_tan(%tan_input) : (f64) -> f64
    
    return %power_result, %ceil_result, %tan_result : i32, f64, f64
  }
}