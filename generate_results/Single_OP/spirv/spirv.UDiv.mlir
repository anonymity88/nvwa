module {
  func.func @main(%a: i32, %b: i32) -> i32 {
    %result = spirv.UDiv %a, %b : i32
    return %result : i32
  }

  func.func @vector_example(%vecA: vector<4xi32>, %vecB: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.UDiv %vecA, %vecB : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}