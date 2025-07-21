module {
  func.func @main(%base: i32, %shift: i32) -> i32 {
    %result = spirv.ShiftRightLogical %base, %shift : i32, i32
    return %result : i32
  }

  func.func @vector_example(%base_vec: vector<4xi32>, %shift_vec: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.ShiftRightLogical %base_vec, %shift_vec : vector<4xi32>, vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}