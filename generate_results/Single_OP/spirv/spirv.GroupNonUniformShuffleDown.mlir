module {
  func.func @main(%val: f32, %delta: i32) -> f32 {
    %result = spirv.GroupNonUniformShuffleDown <Subgroup> %val, %delta : f32, i32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>, %delta: i32) -> vector<4xf32> {
    %result_vec = spirv.GroupNonUniformShuffleDown <Subgroup> %v, %delta : vector<4xf32>, i32
    return %result_vec : vector<4xf32>
  }
}