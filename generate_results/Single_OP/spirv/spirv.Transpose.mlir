module {
  func.func @main(%matrix: !spirv.matrix<2 x vector<3xf32>>) -> !spirv.matrix<3 x vector<2xf32>> {
    %result = spirv.Transpose %matrix : !spirv.matrix<2 x vector<3xf32>> -> !spirv.matrix<3 x vector<2xf32>>
    return %result : !spirv.matrix<3 x vector<2xf32>>
  }
}