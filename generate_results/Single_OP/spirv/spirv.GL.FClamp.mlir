module {
  func.func @main(%x: f32, %min: f32, %max: f32) -> f32 {
    %result = spirv.GL.FClamp %x, %min, %max : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>, %min: vector<4xf32>, %max: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.GL.FClamp %v, %min, %max : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}