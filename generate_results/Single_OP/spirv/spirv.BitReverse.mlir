module {
  func.func @main(%x: i32) -> i32 {
    %result = spirv.BitReverse %x : i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.BitReverse %v : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}