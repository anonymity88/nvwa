module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Ceil %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<3xf32>) -> vector<3xf32> {
    %result_vec = spirv.GL.Ceil %v : vector<3xf32>
    return %result_vec : vector<3xf32>
  }

  func.func @double_example(%d: vector<4xf64>) -> vector<4xf64> {
    %result_double_vec = spirv.GL.Ceil %d : vector<4xf64>
    return %result_double_vec : vector<4xf64>
  }
}