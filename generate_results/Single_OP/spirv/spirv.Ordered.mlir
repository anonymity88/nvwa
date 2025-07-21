module {
  func.func @main(%x: f32, %y: f32) -> i1 {
    %result = spirv.Ordered %x, %y : f32
    return %result : i1
  }

  func.func @vector_example(%v1: vector<4xf32>, %v2: vector<4xf32>) -> vector<4xi1> {
    %result_vec = spirv.Ordered %v1, %v2 : vector<4xf32>
    return %result_vec : vector<4xi1>
  }
}