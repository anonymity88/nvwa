module {
  func.func @main(%x: i32) -> i64 {
    %result = spirv.SConvert %x : i32 to i64
    return %result : i64
  }

  func.func @vector_example(%v: vector<4xi32>) -> vector<4xi64> {
    %result_vec = spirv.SConvert %v : vector<4xi32> to vector<4xi64>
    return %result_vec : vector<4xi64>
  }
}