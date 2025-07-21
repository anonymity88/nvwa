module {
  func.func @main(%src: vector<16xf32>, %a: vector<16xf32>, %b: vector<16xf32>, %k: i16, %rounding: i32) -> vector<16xf32> {
    %dst = x86vector.avx512.mask.scalef %src, %a, %b, %k, %rounding : vector<16xf32>
    return %dst : vector<16xf32>
  }
}