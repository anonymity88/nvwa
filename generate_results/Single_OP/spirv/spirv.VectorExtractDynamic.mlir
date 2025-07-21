module {
  func.func @main(%vec: vector<8xf32>, %index: i32) -> f32 {
    %result = spirv.VectorExtractDynamic %vec[%index] : vector<8xf32>, i32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>, %idx: i32) -> f32 {
    %result_vec = spirv.VectorExtractDynamic %v[%idx] : vector<4xf32>, i32
    return %result_vec : f32
  }
}