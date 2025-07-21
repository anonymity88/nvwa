module {
  func.func @main(%x: i32) -> i32 {
    %result = spirv.BitCount %x : i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.BitCount %v : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}