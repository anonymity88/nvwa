module {
  func.func @main(%value: vector<4xi32>) -> vector<4xi32> {
    %result = spirv.Not %value : vector<4xi32>
    return %result : vector<4xi32>
  }
}