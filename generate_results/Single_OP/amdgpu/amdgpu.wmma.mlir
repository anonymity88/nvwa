module {
  func.func @main(%arg0: vector<8xf16>, %arg1: vector<8xf16>, %arg2: vector<8xf16>) -> vector<8xf16> {
    %result = amdgpu.wmma %arg0 * %arg1 + %arg2 : vector<8xf16>, vector<8xf16>, vector<8xf16>
    return %result : vector<8xf16>
  }
}