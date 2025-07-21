module {
  func.func @main(%arg0: vector<4xf8E5M2FNUZ>) -> f32 {
    %result = amdgpu.ext_packed_fp8 %arg0[2] : vector<4xf8E5M2FNUZ> to f32
    return %result : f32
  }
}