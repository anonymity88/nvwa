module {
  func.func @main(%a: vector<8xf32>, %b: vector<8xf32>) -> vector<8xf32> {
    %dot_result = x86vector.avx.intr.dot %a, %b : vector<8xf32>
    return %dot_result : vector<8xf32>
  }
}