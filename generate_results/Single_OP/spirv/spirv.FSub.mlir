module {
  func.func @main(%a: f32, %b: f32) -> f32 {
    %result = spirv.FSub %a, %b : f32
    return %result : f32
  }

  func.func @vector_example(%vec_a: vector<4xf32>, %vec_b: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.FSub %vec_a, %vec_b : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}