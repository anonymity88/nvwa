module {
  func.func @main(%condition: i1, %true_value: f32, %false_value: f32) -> f32 {
    %result = spirv.Select %condition, %true_value, %false_value : i1, f32
    return %result : f32
  }

  func.func @vector_example(%condition_vec: vector<4xi1>, %true_value_vec: vector<4xf32>, %false_value_vec: vector<4xf32>) -> vector<4xf32> {
    %result_vec = spirv.Select %condition_vec, %true_value_vec, %false_value_vec : vector<4xi1>, vector<4xf32>
    return %result_vec : vector<4xf32>
  }
}