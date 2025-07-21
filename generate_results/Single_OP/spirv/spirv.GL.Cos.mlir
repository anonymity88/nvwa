module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Cos %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<3xf32>) -> vector<3xf32> {
    %result_vec = spirv.GL.Cos %v : vector<3xf32>
    return %result_vec : vector<3xf32>
  }

  func.func @vector_example_f16(%v: vector<4xf16>) -> vector<4xf16> {
    %result_vec_f16 = spirv.GL.Cos %v : vector<4xf16>
    return %result_vec_f16 : vector<4xf16>
  }
}