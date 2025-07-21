module {
  func.func @main(%value: i32) -> i32 {
    %result = spirv.GroupSMax <Workgroup> <Reduce> %value : i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.GroupSMax <Workgroup> <Reduce> %v : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}