module {
  func.func @main(%matA: !spirv.coopmatrix<4x4xf32, Subgroup, MatrixA>, 
                  %matB: !spirv.coopmatrix<4x4xf32, Subgroup, MatrixB>, 
                  %matC: !spirv.coopmatrix<4x4xf32, Subgroup, MatrixAcc>) -> !spirv.coopmatrix<4x4xf32, Subgroup, MatrixAcc> {
    %result = spirv.KHR.CooperativeMatrixMulAdd %matA, %matB, %matC : 
      !spirv.coopmatrix<4x4xf32, Subgroup, MatrixA>, 
      !spirv.coopmatrix<4x4xf32, Subgroup, MatrixB> -> 
      !spirv.coopmatrix<4x4xf32, Subgroup, MatrixAcc>
    return %result : !spirv.coopmatrix<4x4xf32, Subgroup, MatrixAcc>
  }
  
  func.func @vector_example(%matA: !spirv.coopmatrix<8x16xi32, Subgroup, MatrixA>, 
                             %matB: !spirv.coopmatrix<16x4xi32, Subgroup, MatrixB>, 
                             %matC: !spirv.coopmatrix<8x4xi32, Subgroup, MatrixAcc>) -> !spirv.coopmatrix<8x4xi32, Subgroup, MatrixAcc> {
    %result_vec = spirv.KHR.CooperativeMatrixMulAdd %matA, %matB, %matC, <AccSat> : 
      !spirv.coopmatrix<8x16xi32, Subgroup, MatrixA>, 
      !spirv.coopmatrix<16x4xi32, Subgroup, MatrixB> -> 
      !spirv.coopmatrix<8x4xi32, Subgroup, MatrixAcc>
    return %result_vec : !spirv.coopmatrix<8x4xi32, Subgroup, MatrixAcc>
  }
}