module {
  func.func @main(%src: vector<16xf32>, %k: i32, %a: vector<16xf32>, %imm: i16, %rounding: vector<16xi1>) -> vector<16xf32> {
    %res = "x86vector.avx512.intr.mask.rndscale.ps.512"(%src, %k, %a, %imm, %rounding) : (vector<16xf32>, i32, vector<16xf32>, i16, vector<16xi1>) -> vector<16xf32>
    return %res : vector<16xf32>
  }
}