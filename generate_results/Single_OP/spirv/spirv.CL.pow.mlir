module {
  func.func @main(%x: f32, %y: f32) -> f32 {
    %result = spirv.CL.pow %x, %y : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>, %w: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.pow %v, %w : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @multi_dim_vector_example(%v: vector<3xf16>, %w: vector<3xf16>) -> vector<3xf16> {
    %result_vec = spirv.CL.pow %v, %w : vector<3xf16>
    return %result_vec : vector<3xf16>
  }
}