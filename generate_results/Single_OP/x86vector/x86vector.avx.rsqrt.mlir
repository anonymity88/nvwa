module {
  func.func @main(%arg0: vector<8xf32>) -> vector<8xf32> {
    %rsqrt_result = x86vector.avx.rsqrt %arg0 : vector<8xf32>
    return %rsqrt_result : vector<8xf32>
  }
}