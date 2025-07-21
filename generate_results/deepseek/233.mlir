module {
  func.func @main(
    %a_i32: vector<16xi32>, %b_i32: vector<16xi32>,
    %a_i64: vector<8xi64>, %b_i64: vector<8xi64>,
    %src: vector<16xf32>, %k: i32, %a_f32: vector<16xf32>, %imm: i16, %rounding: i32
  ) -> (vector<16xi1>, vector<16xi1>, vector<8xi1>, vector<16xf32>) {
    // Call x86vector.avx512.vp2intersect for i32 vectors
    %k1, %k2 = x86vector.avx512.vp2intersect %a_i32, %b_i32 : vector<16xi32>
    
    // Call x86vector.avx512.intr.vp2intersect.q.512 for i64 vectors
    %res_i64 = "x86vector.avx512.intr.vp2intersect.q.512"(%a_i64, %b_i64) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    
    // Call x86vector.avx512.mask.rndscale for f32 vectors
    %rndscale_result = x86vector.avx512.mask.rndscale %src, %k, %a_f32, %imm, %rounding : vector<16xf32>
    
    return %k1, %k2, %res_i64, %rndscale_result : vector<16xi1>, vector<16xi1>, vector<8xi1>, vector<16xf32>
  }
}