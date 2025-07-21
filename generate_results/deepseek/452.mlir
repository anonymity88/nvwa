module {
  func.func @compute_sqrt(%b: f64) -> f64 {
    %a = math.sqrt %b : f64
    return %a : f64
  }

  func.func @compute_ctpop(%b: i32) -> i32 {
    %a = math.ctpop %b : i32
    return %a : i32
  }

  func.func @compute_absi(%b: i64) -> i64 {
    %a = math.absi %b : i64
    return %a : i64
  }

  func.func @rsqrt64(%float: f64) -> f64 {
    %float_result = math.rsqrt %float : f64
    return %float_result : f64
  }

  func.func @main(%input_sqrt: f64, %input_ctpop: i32, %input_absi: i64) -> (f64, i32, i64) {
    %sqrt_result = call @compute_sqrt(%input_sqrt) : (f64) -> f64
    %ctpop_result = call @compute_ctpop(%input_ctpop) : (i32) -> i32
    %absi_result = call @compute_absi(%input_absi) : (i64) -> i64
    %rsqrt_result = call @rsqrt64(%input_sqrt) : (f64) -> f64
    return %sqrt_result, %ctpop_result, %absi_result : f64, i32, i64
  }
}