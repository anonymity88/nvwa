module {
  func.func @main(%operand1: vector<4xf32>, %operand2: vector<4xf32>) -> vector<4xi1> {
    %result = spirv.FUnordLessThanEqual %operand1, %operand2 : vector<4xf32>
    return %result : vector<4xi1>
  }

  func.func @another_function(%a: f32, %b: f32) -> i1 {
    %result2 = spirv.FUnordLessThanEqual %a, %b : f32
    return %result2 : i1
  }
}