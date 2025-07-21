module {
  func.func @main(%a: vector<4xi32>, %b: vector<4xi32>) -> vector<4xi1> {
    %result = spirv.UGreaterThan %a, %b : vector<4xi32>
    return %result : vector<4xi1>
  }
}