module {
  func.func @main(%value: i32) -> i32 {
    %result = spirv.GroupIAdd <Workgroup> <Reduce> %value : i32
    return %result : i32
  }

  func.func @vector_example(%values: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.GroupIAdd <Subgroup> <Reduce> %values : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}