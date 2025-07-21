module {
  func.func @main(%vector: vector<4xi32>) -> i32 {
    %result = spirv.GroupNonUniformBallotFindMSB <Subgroup> %vector : vector<4xi32>, i32
    return %result : i32
  }

  func.func @example_with_other_types(%vector: vector<4xi64>) -> i64 {
    %result = spirv.GroupNonUniformBallotFindMSB <Subgroup> %vector : vector<4xi64>, i64
    return %result : i64
  }
}