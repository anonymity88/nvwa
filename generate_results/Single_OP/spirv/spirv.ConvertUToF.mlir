module {
  func.func @main(%x: i32) -> f32 {
    %result = spirv.ConvertUToF %x : i32 to f32
    return %result : f32
  }

  func.func @vector_example(%v: vector<4xi32>) -> vector<4xf32> {
    %result_vec = spirv.ConvertUToF %v : vector<4xi32> to vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}