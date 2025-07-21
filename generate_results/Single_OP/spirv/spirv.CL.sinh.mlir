module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.sinh %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.sinh %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
  
  func.func @double_vector_example(%v: vector<8xf64>) -> vector<8xf64> {
    %result_dvec = spirv.CL.sinh %v : vector<8xf64>
    return %result_dvec : vector<8xf64>
  }
}