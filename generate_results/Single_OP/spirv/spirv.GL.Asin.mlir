module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Asin %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.GL.Asin %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @vector_example_hf(%v: vector<3xf16>) -> vector<3xf16> {
    %result_vec_hf = spirv.GL.Asin %v : vector<3xf16>
    return %result_vec_hf : vector<3xf16>
  }
}