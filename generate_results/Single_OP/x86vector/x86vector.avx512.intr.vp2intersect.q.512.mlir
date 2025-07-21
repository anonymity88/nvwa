module {
  func.func @main(%a: vector<8xi64>, %b: vector<8xi64>) -> vector<8xi1> {
    %res = "x86vector.avx512.intr.vp2intersect.q.512"(%a, %b) : (vector<8xi64>, vector<8xi64>) -> vector<8xi1>
    return %res : vector<8xi1>
  }
}