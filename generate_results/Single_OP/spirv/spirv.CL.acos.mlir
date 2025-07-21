module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.acos %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.acos %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}