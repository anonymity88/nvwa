module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.rsqrt %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.rsqrt %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @mixed_example(%v1: vector<3xf32>, %v2: vector<2xf16>) -> (vector<3xf32>, vector<2xf16>) {
    %result_vec1 = spirv.CL.rsqrt %v1 : vector<3xf32>
    %result_vec2 = spirv.CL.rsqrt %v2 : vector<2xf16>
    return %result_vec1, %result_vec2 : vector<3xf32>, vector<2xf16>
  }
}