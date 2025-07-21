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

  func.func @fastmath(%f: f32, %i: i32, %v: vector<4xf32>, %t: tensor<4x4x?xf32>) {
    %0 = math.trunc %f fastmath<fast> : f32
    %1 = math.powf %v, %v fastmath<reassoc,nnan,ninf,nsz,arcp,contract,afn> : vector<4xf32>
    %2 = math.fma %t, %t, %t fastmath<none> : tensor<4x4x?xf32>
    %3 = math.absf %f fastmath<ninf> : f32
    %4 = math.fpowi %f, %i fastmath<fast> : f32, i32
    return
  }

  func.func @main(
    %input_base: f64, 
    %input_power: i32, 
    %input_acos: f64, 
    %input_erf: f64,
    %fast_f: f32,
    %fast_i: i32,
    %fast_v: vector<4xf32>,
    %fast_t: tensor<4x4x?xf32>
  ) -> (f64, f64, f64) {
    %power_result = call @compute_fpowi(%input_base, %input_power) : (f64, i32) -> f64
    
    %acos_result = call @compute_acos(%power_result) : (f64) -> f64
    
    %erf_result = call @compute_erf(%acos_result) : (f64) -> f64
    
    %direct_erf_result = call @compute_erf(%input_erf) : (f64) -> f64

    call @fastmath(%fast_f, %fast_i, %fast_v, %fast_t) : (f32, i32, vector<4xf32>, tensor<4x4x?xf32>) -> ()
    
    return %power_result, %acos_result, %direct_erf_result : f64, f64, f64
  }
}