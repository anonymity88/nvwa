module {
  func.func @main(%x: f32, %y: f32) -> f32 {
    %result = spirv.CL.fmin %x, %y : f32
    return %result : f32
  }

  func.func @vector_example(%v1: vector<4xf32>, %v2: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.fmin %v1, %v2 : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}