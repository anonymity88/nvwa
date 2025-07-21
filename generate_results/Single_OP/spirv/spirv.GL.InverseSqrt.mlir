module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.GL.InverseSqrt %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result = spirv.GL.InverseSqrt %v : vector<4xf32>
    return %result : vector<4xf32>
  }
}