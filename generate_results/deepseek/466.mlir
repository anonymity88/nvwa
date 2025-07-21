module {
  func.func @main(
    %a: vector<16xi32>, 
    %b: vector<16xi32>, 
    %a_dot: vector<8xf32>, 
    %b_dot: vector<8xf32>, 
    %a_intersect: vector<8xi64>, 
    %b_intersect: vector<8xi64>,
    %avx_a: vector<16xf32>,
    %avx_b: vector<8xf64>,
    %i32: i32,
    %i16: i16,
    %i8: i8
  ) -> (vector<16xi1>, vector<16xi1>, vector<8xf32>, vector<8xi1>, vector<16xf32>, vector<8xf64>, vector<16xf32>, vector<8xf64>) {
    // AVX-512 vector operations
    %k1, %k2 = x86vector.avx512.vp2intersect %a, %b : vector<16xi32>
    
    // AVX dot product operation
    %dot_result = call @avx_dot(%a_dot, %b_dot) : (vector<8xf32>, vector<8xf32>) -> vector<8xf32>
    
    // AVX-512 intersect operation
    %res = "x86vector.avx512.intr.vp2intersect.q.512"(%a_intersect, %b_intersect) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    
    // AVX-512 mask and scale operations
    %rndscale_result0, %rndscale_result1, %scalef_result0, %scalef_result1 = call @avx512_mask_scale(%avx_a, %avx_b, %i32, %i16, %i8) : 
      (vector<16xf32>, vector<8xf64>, i32, i16, i8) -> (vector<16xf32>, vector<8xf64>, vector<16xf32>, vector<8xf64>)
    
    return %k1, %k2, %dot_result, %res, %rndscale_result0, %rndscale_result1, %scalef_result0, %scalef_result1 : 
      vector<16xi1>, vector<16xi1>, vector<8xf32>, vector<8xi1>, vector<16xf32>, vector<8xf64>, vector<16xf32>, vector<8xf64>
  }

  func.func @avx_dot(%a: vector<8xf32>, %b: vector<8xf32>) -> (vector<8xf32>) {
    %0 = x86vector.avx.intr.dot %a, %b : vector<8xf32>
    return %0 : vector<8xf32>
  }

  func.func @avx512_mask_scale(
    %a: vector<16xf32>, 
    %b: vector<8xf64>, 
    %i32: i32, 
    %i16: i16, 
    %i8: i8
  ) -> (vector<16xf32>, vector<8xf64>, vector<16xf32>, vector<8xf64>) {
    %0 = x86vector.avx512.mask.rndscale %a, %i32, %a, %i16, %i32 : vector<16xf32>
    %1 = x86vector.avx512.mask.rndscale %b, %i32, %b, %i8, %i32 : vector<8xf64>
    %2 = x86vector.avx512.mask.scalef %a, %a, %a, %i16, %i32 : vector<16xf32>
    %3 = x86vector.avx512.mask.scalef %b, %b, %b, %i8, %i32 : vector<8xf64>
    return %0, %1, %2, %3 : vector<16xf32>, vector<8xf64>, vector<16xf32>, vector<8xf64>
  }
}