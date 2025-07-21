module {
  func.func @main(%x: i16) -> f32 {
    %result = spirv.INTEL.ConvertBF16ToF %x : i16 to f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xi16>) -> vector<4xf32> {
    %result_vec = spirv.INTEL.ConvertBF16ToF %v : vector<4xi16> to vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}