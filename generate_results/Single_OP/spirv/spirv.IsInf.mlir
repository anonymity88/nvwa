module {
  func.func @main(%x: f32) -> i1 {
    %result = spirv.IsInf %x : f32
    return %result : i1
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xi1> {
    %result_vec = spirv.IsInf %v : vector<4xf32>
    return %result_vec : vector<4xi1>
  }
}