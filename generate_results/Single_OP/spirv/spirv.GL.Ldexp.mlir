module {
  func.func @main(%x: f32, %exp: i32) -> f32 {
    %y = spirv.GL.Ldexp %x : f32, %exp : i32 -> f32
    return %y : f32
  }

  func.func @vector_example(%x_vec: vector<4xf32>, %exp_vec: vector<4xi32>) -> vector<4xf32> {
    %y_vec = spirv.GL.Ldexp %x_vec : vector<4xf32>, %exp_vec : vector<4xi32> -> vector<4xf32>
    return %y_vec : vector<4xf32>
  }
}