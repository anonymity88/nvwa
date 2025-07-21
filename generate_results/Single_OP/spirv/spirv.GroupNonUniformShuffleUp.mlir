module {
  func.func @main(%val: f32, %delta: i32) -> f32 {
    %result = spirv.GroupNonUniformShuffleUp <Subgroup> %val, %delta : f32, i32
    return %result : f32
  }
}