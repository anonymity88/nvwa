module {
  func.func @main(%matrix: !spirv.matrix<3 x vector<3xf32>>, %scalar: f32) -> !spirv.matrix<3 x vector<3xf32>> {
    %result = spirv.MatrixTimesScalar %matrix, %scalar : !spirv.matrix<3 x vector<3xf32>>, f32
    return %result : !spirv.matrix<3 x vector<3xf32>>
  }

  func.func @scalar_multiplication_example(%matrix: !spirv.matrix<2 x vector<4xf32>>, %scalar: f32) -> !spirv.matrix<2 x vector<4xf32>> {
    %result_vec = spirv.MatrixTimesScalar %matrix, %scalar : !spirv.matrix<2 x vector<4xf32>>, f32
    return %result_vec : !spirv.matrix<2 x vector<4xf32>>
  }
}