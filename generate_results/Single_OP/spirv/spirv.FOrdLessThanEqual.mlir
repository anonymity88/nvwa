module {
  func.func @main(%a: f32, %b: f32) -> i1 {
    %result = spirv.FOrdLessThanEqual %a, %b : f32
    return %result : i1
  }

  func.func @vector_example(%vec1: vector<4xf32>, %vec2: vector<4xf32>) -> vector<4xi1> {
    %result_vec = spirv.FOrdLessThanEqual %vec1, %vec2 : vector<4xf32>
    return %result_vec : vector<4xi1>
  }
}