module {
  func.func @main(%predicate: i1) -> vector<4xi32> {
    %result = spirv.GroupNonUniformBallot <Subgroup> %predicate : vector<4xi32>
    return %result : vector<4xi32>
  }
}