module {
  func.func @main(%value: vector<4xi32>) -> vector<4xi32> {
    %result = spirv.CL.s_abs %value : vector<4xi32>
    return %result : vector<4xi32>
  }
}