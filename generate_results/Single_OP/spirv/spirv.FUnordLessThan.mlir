module {
  func.func @main(%operand1: vector<4xf32>, %operand2: vector<4xf32>) -> vector<4xi1> {
    %result = spirv.FUnordLessThan %operand1, %operand2 : vector<4xf32>
    return %result : vector<4xi1>
  }
}