module {
  func.func @main(
    %a_dp: vector<8xf32>, 
    %b_dp: vector<8xf32>, 
    %c: i8, 
    %a_dot: vector<8xf32>, 
    %b_dot: vector<8xf32>, 
    %k: vector<16xi1>, 
    %a_compress: vector<16xf32>,
    %k1: vector<16xi1>,
    %a1: vector<16xf32>,
    %k2: vector<8xi1>,
    %a2: vector<8xi64>
  ) -> (vector<8xf32>, vector<8xf32>, vector<16xf32>, vector<16xf32>, vector<16xf32>, vector<8xi64>) {
    // Dot product operations
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a_dp, %b_dp, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    %dot_result = x86vector.avx.intr.dot %a_dot, %b_dot : vector<8xf32>
    
    // Compression operations
    %compress_result = x86vector.avx512.mask.compress %k, %a_compress : vector<16xf32>
    
    // Call to avx512_mask_compress function
    %compress_result_0, %compress_result_1, %compress_result_2 = call @avx512_mask_compress(%k1, %a1, %k2, %a2) 
      : (vector<16xi1>, vector<16xf32>, vector<8xi1>, vector<8xi64>) -> (vector<16xf32>, vector<16xf32>, vector<8xi64>)
    
    return %dp_result, %dot_result, %compress_result, %compress_result_0, %compress_result_1, %compress_result_2 
      : vector<8xf32>, vector<8xf32>, vector<16xf32>, vector<16xf32>, vector<16xf32>, vector<8xi64>
  }

  func.func @avx512_mask_compress(
    %k1: vector<16xi1>, 
    %a1: vector<16xf32>,
    %k2: vector<8xi1>, 
    %a2: vector<8xi64>
  ) -> (vector<16xf32>, vector<16xf32>, vector<8xi64>) {
    %0 = x86vector.avx512.mask.compress %k1, %a1 : vector<16xf32>
    %1 = x86vector.avx512.mask.compress %k1, %a1 {constant_src = dense<5.0> : vector<16xf32>} : vector<16xf32>
    %2 = x86vector.avx512.mask.compress %k2, %a2, %a2 : vector<8xi64>, vector<8xi64>
    return %0, %1, %2 : vector<16xf32>, vector<16xf32>, vector<8xi64>
  }
}