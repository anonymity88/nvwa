module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Sqrt %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<3xf32>) -> vector<3xf32> {
    %result_vec = spirv.GL.Sqrt %v : vector<3xf32>
    return %result_vec : vector<3xf32>
  }

  func.func @double_example(%y: f64) -> f64 {
    %double_result = spirv.GL.Sqrt %y : f64
    return %double_result : f64
  }

  func.func @vector_double_example(%w: vector<4xf64>) -> vector<4xf64> {
    %result_vec_double = spirv.GL.Sqrt %w : vector<4xf64>
    return %result_vec_double : vector<4xf64>
  }
}