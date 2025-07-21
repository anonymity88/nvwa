module {
  func.func @main(%a_dot: vector<8xf32>, %b_dot: vector<8xf32>, %src: vector<16xf32>, %k: i32, %a_rnd: vector<16xf32>, %imm: i16, %rounding: i32, %a_dp: vector<8xf32>, %b_dp: vector<8xf32>, %c: i8) -> (vector<8xf32>, vector<16xf32>, vector<8xf32>) {
    // Compute dot product of 8xf32 vectors
    %dot_result = x86vector.avx.intr.dot %a_dot, %b_dot : vector<8xf32>
    
    // Compute rounded and scaled vector
    %rndscale_result = x86vector.avx512.mask.rndscale %src, %k, %a_rnd, %imm, %rounding : vector<16xf32>
    
    // Compute dot product with control byte
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a_dp, %b_dp, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    
    return %dot_result, %rndscale_result, %dp_result : vector<8xf32>, vector<16xf32>, vector<8xf32>
  }
}