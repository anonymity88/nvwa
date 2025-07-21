module {
  func.func @compute_ceil(%b: f64) -> f64 {
    %a = math.ceil %b : f64
    return %a : f64
  }

  func.func @compute_pow(%b: f64, %c: f64) -> f64 {
    %a = math.powf %b, %c : f64
    return %a : f64
  }

  func.func @compute_trunc(%b: f64) -> f64 {
    %a = math.trunc %b : f64
    return %a : f64
  }

  func.func @cos(%f: f32, %v: vector<4xf32>, %t: tensor<4x4x?xf32>) {
    %0 = math.cos %f : f32
    %1 = math.cos %v : vector<4xf32>
    %2 = math.cos %t : tensor<4x4x?xf32>
    return
  }

  func.func @main(
    %input_ceil: f64, 
    %input_pow_base: f64, 
    %input_pow_exp: f64, 
    %input_trunc: f64,
    %cos_f: f32,
    %cos_v: vector<4xf32>,
    %cos_t: tensor<4x4x?xf32>
  ) -> (f64, f64, f64) {
    %ceil_result = call @compute_ceil(%input_ceil) : (f64) -> f64
    %pow_result = call @compute_pow(%input_pow_base, %input_pow_exp) : (f64, f64) -> f64
    %trunc_result = call @compute_trunc(%input_trunc) : (f64) -> f64
    
    // Call the cos function with the provided arguments
    call @cos(%cos_f, %cos_v, %cos_t) : (f32, vector<4xf32>, tensor<4x4x?xf32>) -> ()
    
    return %ceil_result, %pow_result, %trunc_result : f64, f64, f64
  }
}