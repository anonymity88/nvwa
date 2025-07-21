module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Sin %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.GL.Sin %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @vector_example_f16(%v: vector<3xf16>) -> vector<3xf16> {
    %result_vec_f16 = spirv.GL.Sin %v : vector<3xf16>
    return %result_vec_f16 : vector<3xf16>
  }
}