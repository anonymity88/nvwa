module {
  func.func @main(
    %a_dot: vector<8xf32>, %b_dot: vector<8xf32>,
    %a_vp2intersect_q: vector<8xi64>, %b_vp2intersect_q: vector<8xi64>,
    %a_vp2intersect: vector<16xi32>, %b_vp2intersect: vector<16xi32>
  ) -> (vector<8xf32>, vector<8xi1>, vector<16xi1>, vector<16xi1>) {
    // Compute dot product of two float vectors
    %dot_result = x86vector.avx.intr.dot %a_dot, %b_dot : vector<8xf32>
    
    // Compute VP2INTERSECT for 64-bit integer vectors
    %vp2intersect_q_result = "x86vector.avx512.intr.vp2intersect.q.512"(%a_vp2intersect_q, %b_vp2intersect_q) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    
    // Compute VP2INTERSECT for 32-bit integer vectors (returns two masks)
    %k1, %k2 = x86vector.avx512.vp2intersect %a_vp2intersect, %b_vp2intersect : vector<16xi32>
    
    return %dot_result, %vp2intersect_q_result, %k1, %k2 : vector<8xf32>, vector<8xi1>, vector<16xi1>, vector<16xi1>
  }
}