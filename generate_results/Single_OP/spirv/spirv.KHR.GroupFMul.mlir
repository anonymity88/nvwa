module {
  func.func @main(%value: f32) -> f32 {
    %result = spirv.KHR.GroupFMul <Workgroup> <Reduce> %value : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.KHR.GroupFMul <Subgroup> <Reduce> %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}