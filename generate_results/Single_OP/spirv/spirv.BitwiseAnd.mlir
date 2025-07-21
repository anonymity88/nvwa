module {
  func.func @main(%operand1: i32, %operand2: i32) -> i32 {
    %result = spirv.BitwiseAnd %operand1, %operand2 : i32
    return %result : i32
  }

  func.func @vector_example(%v1: vector<4xi32>, %v2: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.BitwiseAnd %v1, %v2 : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}