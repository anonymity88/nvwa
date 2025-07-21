module {
  func.func @main(%a: f32, %b: f32, %c: f32) -> f32 {
    %result = spirv.CL.fma %a, %b, %c : f32
    return %result : f32
  }

  func.func @vector_example(%a: vector<4xf32>, %b: vector<4xf32>, %c: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.fma %a, %b, %c : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}