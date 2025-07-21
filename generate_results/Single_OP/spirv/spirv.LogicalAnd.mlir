module {
  func.func @main(%operand1: vector<4xi1>, %operand2: vector<4xi1>) -> vector<4xi1> {
    %result = spirv.LogicalAnd %operand1, %operand2 : vector<4xi1>
    return %result : vector<4xi1>
  }
}