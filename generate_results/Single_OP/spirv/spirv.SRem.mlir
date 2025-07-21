module {
  func.func @main(%operand1: vector<4xi32>, %operand2: vector<4xi32>) -> vector<4xi32> {
    %result = spirv.SRem %operand1, %operand2 : vector<4xi32>
    return %result : vector<4xi32>
  }
}