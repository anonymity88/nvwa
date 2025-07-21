module {
  func.func @main(%base: vector<4xi32>, %shift: vector<4xi16>) -> vector<4xi32> {
    %result = spirv.ShiftRightArithmetic %base, %shift : vector<4xi32>, vector<4xi16>
    return %result : vector<4xi32>
  }
}