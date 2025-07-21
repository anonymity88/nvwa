module {
  func.func @main(%a: i32, %b: i32) -> i32 {
    %result = spirv.ISub %a, %b : i32
    return %result : i32
  }

  func.func @vector_example(%v1: vector<4xi32>, %v2: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.ISub %v1, %v2 : vector<4xi32>
    return %result_vec : vector<4xi32>
  }

  func.func @large_example(%v1: vector<8xi32>, %v2: vector<8xi32>) -> vector<8xi32> {
    %result_large_vec = spirv.ISub %v1, %v2 : vector<8xi32>
    return %result_large_vec : vector<8xi32>
  }
}