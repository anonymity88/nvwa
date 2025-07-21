module {
  func.func @main(%a_dp: vector<8xf32>, %b_dp: vector<8xf32>, %c: i8, %a_dot: vector<8xf32>, %b_dot: vector<8xf32>, %k: vector<16xi1>, %a_compress: vector<16xf32>) -> (vector<8xf32>, vector<8xf32>, vector<16xf32>) {
    // Call x86vector.avx.intr.dp.ps.256
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a_dp, %b_dp, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    
    // Call x86vector.avx.intr.dot
    %dot_result = x86vector.avx.intr.dot %a_dot, %b_dot : vector<8xf32>
    
    // Call x86vector.avx512.mask.compress
    %compress_result = x86vector.avx512.mask.compress %k, %a_compress : vector<16xf32>
    
    return %dp_result, %dot_result, %compress_result : vector<8xf32>, vector<8xf32>, vector<16xf32>
  }
}