module {
  func.func @compute_fpowi(%base: f64, %power: i32) -> f64 {
    %result = math.fpowi %base, %power : f64, i32
    return %result : f64
  }

  func.func @compute_acos(%b: f64) -> f64 {
    %a = math.acos %b : f64
    return %a : f64
  }

  func.func @compute_erf(%b: f64) -> f64 {
    %a = math.erf %b : f64
    return %a : f64
  }

  func.func @main(%input_base: f64, %input_power: i32, %input_acos: f64, %input_erf: f64) -> (f64, f64, f64) {
    // Compute power operation
    %power_result = call @compute_fpowi(%input_base, %input_power) : (f64, i32) -> f64
    
    // Compute acos operation (using power result as input)
    %acos_result = call @compute_acos(%power_result) : (f64) -> f64
    
    // Compute erf operation (using acos result as input)
    %erf_result = call @compute_erf(%acos_result) : (f64) -> f64
    
    // Also compute erf on the original input for demonstration
    %direct_erf_result = call @compute_erf(%input_erf) : (f64) -> f64
    
    // Return all three results
    return %power_result, %acos_result, %direct_erf_result : f64, f64, f64
  }
}