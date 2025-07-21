module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.Floor %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<3xf32>) -> vector<3xf32> {
    %result_vec = spirv.GL.Floor %v : vector<3xf32>
    return %result_vec : vector<3xf32>
  }

  func.func @double_vector_example(%v: vector<4xf64>) -> vector<4xf64> {
    %result_vec = spirv.GL.Floor %v : vector<4xf64>
    return %result_vec : vector<4xf64>
  }
}