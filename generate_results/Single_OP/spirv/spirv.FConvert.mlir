module {
  func.func @main(%x: f32) -> f64 {
    %result = spirv.FConvert %x : f32 to f64
    return %result : f64
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xf64> {
    %result_vec = spirv.FConvert %v : vector<4xf32> to vector<4xf64>
    return %result_vec : vector<4xf64>
  }
}