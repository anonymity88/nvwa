module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.tanh %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.tanh %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @multi_dim_example(%m: vector<2xf32>) -> vector<2xf32> {
    %result_mat = spirv.CL.tanh %m : vector<2xf32>
    return %result_mat : vector<2xf32>
  }
}