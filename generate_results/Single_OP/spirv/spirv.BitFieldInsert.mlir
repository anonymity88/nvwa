module {
  func.func @main(%base: vector<4xi32>, %insert: vector<4xi32>, %offset: i8, %count: i8) -> vector<4xi32> {
    %result = spirv.BitFieldInsert %base, %insert, %offset, %count : vector<4xi32>, i8, i8
    return %result : vector<4xi32>
  }
}