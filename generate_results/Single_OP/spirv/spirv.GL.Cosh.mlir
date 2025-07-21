module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Cosh %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.GL.Cosh %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @vector_example_half_precision(%v: vector<3xf16>) -> vector<3xf16> {
    %result_vec_half = spirv.GL.Cosh %v : vector<3xf16>
    return %result_vec_half : vector<3xf16>
  }
}