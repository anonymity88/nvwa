module {
  func.func @main(%x: f32, %y: f32) -> f32 {
    %result = spirv.FMul %x, %y : f32
    return %result : f32
  }

  func.func @vector_example(%v1: vector<4xf32>, %v2: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.FMul %v1, %v2 : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @double_precision_example(%a: f64, %b: f64) -> f64 {
    %result_double = spirv.FMul %a, %b : f64
    return %result_double : f64
  }

  func.func @vector_double_precision_example(%vec1: vector<4xf64>, %vec2: vector<4xf64>) -> vector<4xf64> {
    %result_double_vec = spirv.FMul %vec1, %vec2 : vector<4xf64>
    return %result_double_vec : vector<4xf64>
  }
}