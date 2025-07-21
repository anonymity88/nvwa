module {
  func.func @main(%val: f32, %mask: i32) -> f32 {
    %result = spirv.GroupNonUniformShuffleXor <Subgroup> %val, %mask : f32, i32
    return %result : f32
  }
  
  func.func @vector_example(%v: vector<4xf32>, %mask: i32) -> vector<4xf32> {
    %result_vec = spirv.GroupNonUniformShuffleXor <Subgroup> %v, %mask : vector<4xf32>, i32
    return %result_vec : vector<4xf32>
  }
}