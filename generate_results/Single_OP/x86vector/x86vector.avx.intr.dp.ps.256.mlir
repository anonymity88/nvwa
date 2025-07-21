module {
  func.func @main(%a: vector<8xf32>, %b: vector<8xf32>, %c: i8) -> vector<8xf32> {
    %res = "x86vector.avx.intr.dp.ps.256"(%a, %b, %c) : (vector<8xf32>, vector<8xf32>, i8) -> vector<8xf32>
    return %res : vector<8xf32>
  }
}