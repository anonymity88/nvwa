module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.FSign %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.GL.FSign %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @int_example(%y: vector<3xf16>) -> vector<3xf16> {
    %result_int_vec = spirv.GL.FSign %y : vector<3xf16>
    return %result_int_vec : vector<3xf16>
  }
}