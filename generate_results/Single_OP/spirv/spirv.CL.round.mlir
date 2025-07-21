module {
  func.func @main(%x: f32) -> f32 {
    %result = spirv.CL.round %x : f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.round %v : vector<4xf32>
    return %result_vec : vector<4xf32>
  }
  
  func.func @float16_example(%y: f16) -> f16 {
    %result_f16 = spirv.CL.round %y : f16
    return %result_f16 : f16
  }

  func.func @vector_example_f16(%v_f16: vector<4xf16>) -> vector<4xf16> {
    %result_vec_f16 = spirv.CL.round %v_f16 : vector<4xf16>
    return %result_vec_f16 : vector<4xf16>
  }
}