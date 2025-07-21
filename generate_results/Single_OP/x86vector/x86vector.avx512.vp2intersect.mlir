module {
  func.func @main(%a: vector<16xi32>, %b: vector<16xi32>) -> (vector<16xi1>, vector<16xi1>) {
    %k1, %k2 = x86vector.avx512.vp2intersect %a, %b : vector<16xi32>
    return %k1, %k2 : vector<16xi1>, vector<16xi1>
  }
}