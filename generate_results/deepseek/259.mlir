module {
  func.func @main(
    %a_dot: vector<8xf32>, 
    %b_dot: vector<8xf32>, 
    %src: vector<16xf32>, 
    %k: i32, 
    %a_rnd: vector<16xf32>, 
    %imm: i16, 
    %rounding: i32, 
    %a_dp: vector<8xf32>, 
    %b_dp: vector<8xf32>, 
    %c: i8,
    %a_scalef: vector<16xf32>,
    %b_scalef: vector<8xf64>,
    %i32_scalef: i32,
    %i16_scalef: i16,
    %i8_scalef: i8
  ) -> (vector<8xf32>, vector<16xf32>, vector<8xf32>, vector<16xf32>, vector<8xf64>) {
    // AVX dot product operation
    %dot_result = x86vector.avx.intr.dot %a_dot, %b_dot : vector<8xf32>
    
    // AVX512 rounding and scaling operation
    %rndscale_result = x86vector.avx512.mask.rndscale %src, %k, %a_rnd, %imm, %rounding : vector<16xf32>
    
    // AVX dot product with control
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a_dp, %b_dp, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    
    // Call to AVX512 scalef function
    %scalef_result_f32, %scalef_result_f64 = call @avx512_scalef(%a_scalef, %b_scalef, %i32_scalef, %i16_scalef, %i8_scalef) : 
      (vector<16xf32>, vector<8xf64>, i32, i16, i8) -> (vector<16xf32>, vector<8xf64>)
    
    return %dot_result, %rndscale_result, %dp_result, %scalef_result_f32, %scalef_result_f64 : 
      vector<8xf32>, vector<16xf32>, vector<8xf32>, vector<16xf32>, vector<8xf64>
  }

  func.func @avx512_scalef(
    %a: vector<16xf32>, 
    %b: vector<8xf64>, 
    %i32: i32, 
    %i16: i16, 
    %i8: i8
  ) -> (vector<16xf32>, vector<8xf64>) {
    %0 = x86vector.avx512.mask.scalef %a, %a, %a, %i16, %i32 : vector<16xf32>
    %1 = x86vector.avx512.mask.scalef %b, %b, %b, %i8, %i32 : vector<8xf64>
    return %0, %1 : vector<16xf32>, vector<8xf64>
  }
}