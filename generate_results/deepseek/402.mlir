module {
  func.func @main(
    %a: vector<8xf32>, 
    %b: vector<8xf32>, 
    %c: i8, 
    %src: vector<16xf32>, 
    %a_scale: vector<16xf32>, 
    %b_scale: vector<16xf32>, 
    %k: i16, 
    %rounding: i32,
    %avx_a: vector<16xf32>,
    %avx_b: vector<8xf64>,
    %avx_i32: i32,
    %avx_i16: i16,
    %avx_i8: i8
  ) -> (vector<8xf32>, vector<8xf32>, vector<16xf32>, vector<16xf32>, vector<8xf64>) {
    // AVX dot product operations
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a, %b, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    %dot_result = x86vector.avx.intr.dot %a, %b : vector<8xf32>
    
    // AVX512 scale operations
    %scaled_result = x86vector.avx512.mask.scalef %src, %a_scale, %b_scale, %k, %rounding : vector<16xf32>
    
    // Call to AVX512 scalef function
    %avx_scaled_f32, %avx_scaled_f64 = call @avx512_scalef(%avx_a, %avx_b, %avx_i32, %avx_i16, %avx_i8) 
      : (vector<16xf32>, vector<8xf64>, i32, i16, i8) -> (vector<16xf32>, vector<8xf64>)
    
    return %dp_result, %dot_result, %scaled_result, %avx_scaled_f32, %avx_scaled_f64 
      : vector<8xf32>, vector<8xf32>, vector<16xf32>, vector<16xf32>, vector<8xf64>
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