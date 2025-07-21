module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.asinh %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.asinh %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @double_precision_example(%y: vector<2xf64>) -> vector<2xf64> {
    %result_double_vec = spirv.CL.asinh %y : vector<2xf64>
    return %result_double_vec : vector<2xf64>
  }
}