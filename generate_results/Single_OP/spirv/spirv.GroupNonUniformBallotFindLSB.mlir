module {
  func.func @main(%value: vector<4xi32>) -> i32 {
    %result = spirv.GroupNonUniformBallotFindLSB <Subgroup> %value : vector<4xi32>, i32
    return %result : i32
  }
}