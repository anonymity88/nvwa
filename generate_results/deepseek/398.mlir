module {
  func.func @combined(
    %matrix: !spirv.matrix<2 x vector<3xf32>>,
    %operand1: vector<4xi32>,
    %operand2: vector<4xi32>,
    %a: i32,
    %b: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>
  ) -> (
    !spirv.matrix<3 x vector<2xf32>>,
    vector<4xi1>,
    !spirv.struct<(i32, i32)>,
    !spirv.struct<(vector<4xi32>, vector<4xi32>)>,
    vector<3xi32>
  ) {
    // Perform matrix transpose operation
    %transpose_result = spirv.Transpose %matrix : !spirv.matrix<2 x vector<3xf32>> -> !spirv.matrix<3 x vector<2xf32>>
    
    // Perform unsigned less-than comparison
    %compare_result = spirv.ULessThan %operand1, %operand2 : vector<4xi32>
    
    // Perform integer add with carry
    %iaddcarry_result = spirv.IAddCarry %a, %b : !spirv.struct<(i32, i32)>
    
    // Perform vector integer add with carry
    %vector_iaddcarry_result = spirv.IAddCarry %v1, %v2 : !spirv.struct<(vector<4xi32>, vector<4xi32>)>
    
    // Call constant folding function for vector left shift
    %shift_result = call @const_fold_vector_lsl() : () -> vector<3xi32>
    
    return %transpose_result, %compare_result, %iaddcarry_result, %vector_iaddcarry_result, %shift_result : 
           !spirv.matrix<3 x vector<2xf32>>, vector<4xi1>, !spirv.struct<(i32, i32)>, !spirv.struct<(vector<4xi32>, vector<4xi32>)>, vector<3xi32>
  }

  func.func @const_fold_vector_lsl() -> vector<3xi32> {
    %c1 = spirv.Constant dense<[1, -1, 127]> : vector<3xi32>
    %c2 = spirv.Constant dense<[31, 16, 13]> : vector<3xi32>
    %0 = spirv.ShiftLeftLogical %c1, %c2 : vector<3xi32>, vector<3xi32>
    return %0 : vector<3xi32>
  }

  // Additional utility functions that could be called from @combined
  func.func @bitwise_and_x_0(%arg0 : i32, %arg1 : vector<3xi32>) -> (i32, vector<3xi32>) {
    %c0 = spirv.Constant 0 : i32
    %cv0 = spirv.Constant dense<0> : vector<3xi32>
    %0 = spirv.BitwiseAnd %arg0, %c0 : i32
    %1 = spirv.BitwiseAnd %arg1, %cv0 : vector<3xi32>
    return %0, %1 : i32, vector<3xi32>
  }
}