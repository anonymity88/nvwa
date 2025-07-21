module {
  func.func @main(
    %arg0: vector<8xf32>, 
    %a: vector<8xf32>, 
    %b: vector<8xf32>, 
    %c: i8, 
    %x: vector<8xi64>, 
    %y: vector<8xi64>,
    %avx512_a: vector<16xf32>,
    %avx512_b: vector<8xf64>,
    %i32: i32,
    %i16: i16,
    %i8: i8
  ) -> (vector<8xf32>, vector<8xi1>, vector<8xf32>, vector<16xf32>, vector<8xf64>) {
    // AVX operations
    %rsqrt_result = x86vector.avx.rsqrt %arg0 : vector<8xf32>
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a, %b, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    %intersect_result = "x86vector.avx512.intr.vp2intersect.q.512"(%x, %y) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    %dot_result = x86vector.avx.intr.dot %a, %b : vector<8xf32>
    
    // AVX512 operations via function call
    %rndscale_result_0, %rndscale_result_1 = call @avx512_mask_rndscale(%avx512_a, %avx512_b, %i32, %i16, %i8) : 
      (vector<16xf32>, vector<8xf64>, i32, i16, i8) -> (vector<16xf32>, vector<8xf64>)
    
    return %rsqrt_result, %intersect_result, %dot_result, %rndscale_result_0, %rndscale_result_1 : 
      vector<8xf32>, vector<8xi1>, vector<8xf32>, vector<16xf32>, vector<8xf64>
  }
  
  func.func @avx512_mask_rndscale(
    %a: vector<16xf32>, 
    %b: vector<8xf64>, 
    %i32: i32, 
    %i16: i16, 
    %i8: i8
  ) -> (vector<16xf32>, vector<8xf64>) {
    %0 = x86vector.avx512.mask.rndscale %a, %i32, %a, %i16, %i32 : vector<16xf32>
    %1 = x86vector.avx512.mask.rndscale %b, %i32, %b, %i8, %i32 : vector<8xf64>
    return %0, %1 : vector<16xf32>, vector<8xf64>
  }
}