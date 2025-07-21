module {
  func.func @main(%x: i32, %y: i32) -> i32 {
    %result = spirv.CL.s_min %x, %y : i32
    return %result : i32
  }

  func.func @vector_example(%vec1: vector<4xi16>, %vec2: vector<4xi16>) -> vector<4xi16> {
    %result_vec = spirv.CL.s_min %vec1, %vec2 : vector<4xi16>
    return %result_vec : vector<4xi16>
  }
}