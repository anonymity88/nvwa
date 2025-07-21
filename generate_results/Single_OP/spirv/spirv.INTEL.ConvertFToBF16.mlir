module {
  func.func @main(%a: f32) -> i16 {
    %result = spirv.INTEL.ConvertFToBF16 %a : f32 to i16
    return %result : i16
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xi16> {
    %result_vec = spirv.INTEL.ConvertFToBF16 %v : vector<4xf32> to vector<4xi16>
    return %result_vec : vector<4xi16>
  }
}