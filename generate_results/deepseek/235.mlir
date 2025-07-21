module {
  func.func @main(%a: vector<8xf32>, %b: vector<8xf32>, %c: i8, %src: vector<16xf32>, %a_scale: vector<16xf32>, %b_scale: vector<16xf32>, %k: i16, %rounding: i32) -> (vector<8xf32>, vector<8xf32>, vector<16xf32>) {
    // Call x86vector.avx.intr.dp.ps.256
    %dp_result = "x86vector.avx.intr.dp.ps.256"(%a, %b, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    
    // Call x86vector.avx.intr.dot using the same inputs as dp.ps
    %dot_result = x86vector.avx.intr.dot %a, %b : vector<8xf32>
    
    // Call x86vector.avx512.mask.scalef with separate inputs
    %scaled_result = x86vector.avx512.mask.scalef %src, %a_scale, %b_scale, %k, %rounding : vector<16xf32>
    
    return %dp_result, %dot_result, %scaled_result : vector<8xf32>, vector<8xf32>, vector<16xf32>
  }
}