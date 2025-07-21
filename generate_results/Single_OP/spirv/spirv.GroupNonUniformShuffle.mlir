module {
  func.func @main(%val: f32, %id: i32) -> f32 {
    %result = spirv.GroupNonUniformShuffle <Subgroup> %val, %id : f32, i32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>, %id: i32) -> vector<4xf32> {
    %result_vec = spirv.GroupNonUniformShuffle <Subgroup> %v, %id : vector<4xf32>, i32
    return %result_vec : vector<4xf32>
  }
}