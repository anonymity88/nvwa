module {
  func.func @main(%base: vector<3xi32>, %offset: i8, %count: i8) -> vector<3xi32> {
    %result = spirv.BitFieldUExtract %base, %offset, %count : vector<3xi32>, i8, i8
    return %result : vector<3xi32>
  }

  func.func @vector_example(%base_vec: vector<4xi32>, %offset_vec: i8, %count_vec: i8) -> vector<4xi32> {
    %result_vec = spirv.BitFieldUExtract %base_vec, %offset_vec, %count_vec : vector<4xi32>, i8, i8
    return %result_vec : vector<4xi32>
  }
}