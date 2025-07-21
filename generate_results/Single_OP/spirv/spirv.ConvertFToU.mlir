module {
  func.func @main(%a: f32) -> i32 {
    %result = spirv.ConvertFToU %a : f32 to i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<4xi32> {
    %result_vec = spirv.ConvertFToU %v : vector<4xf32> to vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}