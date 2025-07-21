module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Sinh %x : f32
    return %result : f32
  }

  func.func @another_func(%vec: vector<3xf16>) -> vector<3xf16> {
    %result_vec = spirv.GL.Sinh %vec : vector<3xf16>
    return %result_vec : vector<3xf16>
  }
}