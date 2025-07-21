module {
  func.func @main(%value: vector<4xi1>) -> vector<4xi1> {
    %result = spirv.LogicalNot %value : vector<4xi1>
    return %result : vector<4xi1>
  }
}