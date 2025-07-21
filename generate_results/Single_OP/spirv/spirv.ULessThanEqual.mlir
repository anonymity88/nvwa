module {
  func.func @main(%a: i32, %b: i32) -> i1 {
    %result = spirv.ULessThanEqual %a, %b : i32
    return %result : i1
  }

  func.func @vector_example(%vec1: vector<4xi32>, %vec2: vector<4xi32>) -> vector<4xi1> {
    %result_vec = spirv.ULessThanEqual %vec1, %vec2 : vector<4xi32>
    return %result_vec : vector<4xi1>
  }
}