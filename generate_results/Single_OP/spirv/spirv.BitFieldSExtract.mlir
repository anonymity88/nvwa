module {
  func.func @main(%base: i32, %offset: i8, %count: i8) -> i32 {
    %result = spirv.BitFieldSExtract %base, %offset, %count : i32, i8, i8
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xi32>, %offset: i8, %count: i8) -> vector<4xi32> {
    %result_vec = spirv.BitFieldSExtract %v, %offset, %count : vector<4xi32>, i8, i8
    return %result_vec : vector<4xi32>
  }
}