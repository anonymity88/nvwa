module {
  func.func @main(%src: vector<16xf32>, %k: i32, %a: vector<16xf32>, %imm: i16, %rounding: i32) -> vector<16xf32> {
    %rndscale_result = x86vector.avx512.mask.rndscale %src, %k, %a, %imm, %rounding : vector<16xf32>
    return %rndscale_result : vector<16xf32>
  }
}