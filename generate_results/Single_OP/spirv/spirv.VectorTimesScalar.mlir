module {
  func.func @main(%vector: vector<4xf32>, %scalar: f32) -> vector<4xf32> {
    %result = spirv.VectorTimesScalar %vector, %scalar : (vector<4xf32>, f32) -> vector<4xf32>
    return %result : vector<4xf32>
  }

  func.func @vector_example(%v: vector<3xf32>, %s: f32) -> vector<3xf32> {
    %result_vec = spirv.VectorTimesScalar %v, %s : (vector<3xf32>, f32) -> vector<3xf32>
    return %result_vec : vector<3xf32>
  }
}