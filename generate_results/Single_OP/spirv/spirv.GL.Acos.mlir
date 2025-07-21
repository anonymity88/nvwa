module {
  func.func @main(%x: f32, %y: vector<4xf32>) -> (f32, vector<4xf32>) {
    %result_scalar = spirv.GL.Acos %x : f32
    %result_vector = spirv.GL.Acos %y : vector<4xf32>
    return %result_scalar, %result_vector : f32, vector<4xf32>
  }
}