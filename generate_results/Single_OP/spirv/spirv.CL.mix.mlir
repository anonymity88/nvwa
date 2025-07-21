module {
  func.func @main(%x: f32, %y: f32, %a: f32) -> f32 {
    %result = spirv.CL.mix %x, %y, %a : f32
    return %result : f32
  }

  func.func @vector_example(%x: vector<4xf32>, %y: vector<4xf32>, %a: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.CL.mix %x, %y, %a : vector<4xf32>
    return %result_vec : vector<4xf32>
  }

  func.func @vector_example_short(%x: vector<3xf16>, %y: vector<3xf16>, %a: vector<3xf16>) -> vector<3xf16> {
    %result_vec_short = spirv.CL.mix %x, %y, %a : vector<3xf16>
    return %result_vec_short : vector<3xf16>
  }
}