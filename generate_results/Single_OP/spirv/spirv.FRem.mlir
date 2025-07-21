module {
  func.func @main(%a: f32, %b: f32) -> f32 {
    %result = spirv.FRem %a, %b : f32
    return %result : f32
  }

  func.func @vector_example(%v1: vector<4xf32>, %v2: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.FRem %v1, %v2 : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}