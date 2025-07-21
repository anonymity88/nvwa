module {
  func.func @main(%v1: vector<4xf32>, %v2: vector<4xf32>) -> f32 {
    %result = spirv.Dot %v1, %v2 : vector<4xf32> -> f32
    return %result : f32
  }

  func.func @vector_example(%v1: vector<2xf64>, %v2: vector<2xf64>) -> f64 {
    %result_vec = spirv.Dot %v1, %v2 : vector<2xf64> -> f64
    return %result_vec : f64
  }
}