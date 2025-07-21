module {
  func.func @main(%a: f32, %b: f32) -> i1 {
    %result = spirv.FUnordGreaterThanEqual %a, %b : f32
    return %result : i1
  }

  func.func @vector_example(%v1: vector<4xf32>, %v2: vector<4xf32>) -> vector<4xi1> {
    %result_vec = spirv.FUnordGreaterThanEqual %v1, %v2 : vector<4xf32>
    return %result_vec : vector<4xi1>
  }
}