module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Atan %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.GL.Atan %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @half_precision_example(%h: vector<2xf16>) -> vector<2xf16> {
    %result_half_vec = spirv.GL.Atan %h : vector<2xf16>
    return %result_half_vec : vector<2xf16>
  }
}