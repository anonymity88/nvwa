module {
  func.func @main(%lhs: vector<4xi32>, %rhs: vector<4xi32>) -> vector<4xi32> {
    %result = spirv.GL.UMin %lhs, %rhs : vector<4xi32>
    return %result : vector<4xi32>
  }
}