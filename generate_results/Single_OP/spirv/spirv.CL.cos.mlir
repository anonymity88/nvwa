module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.cos %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.cos %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @double_precision_example(%v: vector<4xf64>) -> vector<4xf64> {
    %result_vec_double = spirv.CL.cos %v : vector<4xf64>
    return %result_vec_double : vector<4xf64>
  }
}