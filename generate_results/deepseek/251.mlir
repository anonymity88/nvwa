module {
  func.func @main(
    %a_dot: vector<8xf32>, %b_dot: vector<8xf32>,
    %a_vp2intersect_q: vector<8xi64>, %b_vp2intersect_q: vector<8xi64>,
    %a_vp2intersect: vector<16xi32>, %b_vp2intersect: vector<16xi32>,
    %a_rndscale: vector<16xf32>, %b_rndscale: vector<8xf64>,
    %i32: i32, %i16: i16, %i8: i8
  ) -> (vector<8xf32>, vector<8xi1>, vector<16xi1>, vector<16xi1>, vector<16xf32>, vector<8xf64>) {
    // Vector dot product operation
    %dot_result = x86vector.avx.intr.dot %a_dot, %b_dot : vector<8xf32>
    
    // VP2INTERSECT.Q operation
    %vp2intersect_q_result = "x86vector.avx512.intr.vp2intersect.q.512"(%a_vp2intersect_q, %b_vp2intersect_q) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    
    // VP2INTERSECT operation
    %k1, %k2 = x86vector.avx512.vp2intersect %a_vp2intersect, %b_vp2intersect : vector<16xi32>
    
    // Call to avx512_mask_rndscale function
    %rndscale_result_0, %rndscale_result_1 = call @avx512_mask_rndscale(%a_rndscale, %b_rndscale, %i32, %i16, %i8) : (vector<16xf32>, vector<8xf64>, i32, i16, i8) -> (vector<16xf32>, vector<8xf64>)
    
    return %dot_result, %vp2intersect_q_result, %k1, %k2, %rndscale_result_0, %rndscale_result_1 : 
      vector<8xf32>, vector<8xi1>, vector<16xi1>, vector<16xi1>, vector<16xf32>, vector<8xf64>
  }
  
  func.func @avx512_mask_rndscale(%a: vector<16xf32>, %b: vector<8xf64>, %i32: i32, %i16: i16, %i8: i8)
    -> (vector<16xf32>, vector<8xf64>) {
    %0 = x86vector.avx512.mask.rndscale %a, %i32, %a, %i16, %i32 : vector<16xf32>
    %1 = x86vector.avx512.mask.rndscale %b, %i32, %b, %i8, %i32 : vector<8xf64>
    return %0, %1 : vector<16xf32>, vector<8xf64>
  }
}