module {
  func.func @main(%value: vector<4xf32>) -> vector<4xi1> {
    %result = spirv.IsNan %value : vector<4xf32>
    return %result : vector<4xi1>
  }
}