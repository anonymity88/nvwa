module {
  func.func @main(%k: vector<16xi1>, %a: vector<16xf32>) -> vector<16xf32> {
    %dst = x86vector.avx512.mask.compress %k, %a : vector<16xf32>
    return %dst : vector<16xf32>
  }
}