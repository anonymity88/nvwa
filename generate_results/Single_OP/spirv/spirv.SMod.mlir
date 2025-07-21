module {
  func.func @main(%a: i32, %b: i32) -> i32 {
    %result = spirv.SMod %a, %b : i32
    return %result : i32
  }

  func.func @vector_example(%v1: vector<4xi32>, %v2: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.SMod %v1, %v2 : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}