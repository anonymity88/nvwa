module {
  func.func @main() -> (i1, vector<4xi1>, i64, i8, i8) {
    // Scalar comparison
    %lhs_scalar = arith.constant 5 : i32
    %rhs_scalar = arith.constant 10 : i32
    %cmp_result = arith.cmpi slt, %lhs_scalar, %rhs_scalar : i32
    
    // Vector comparison
    %lhs_vector = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %rhs_vector = arith.constant dense<[1, 2, 3, 5]> : vector<4xi32>
    %vector_cmp_result = arith.cmpi eq, %lhs_vector, %rhs_vector : vector<4xi32>

    // Scalar XOR
    %b_xor = arith.constant 5 : i64
    %c_xor = arith.constant 3 : i64
    %scalar_xor_result = arith.xori %b_xor, %c_xor : i64
    
    // Vector XOR
    %g_xor = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %h_xor = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>
    %vector_xor_result = arith.xori %g_xor, %h_xor : vector<4xi32>
    
    // Tensor XOR
    %y_xor = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %z_xor = arith.constant dense<[[5, 6], [7, 8]]> : tensor<2x2xi8>
    %tensor_xor_result = arith.xori %y_xor, %z_xor : tensor<2x2xi8>

    // Scalar division
    %b_div = arith.constant 6 : i64
    %c_div = arith.constant 2 : i64
    %div_result = arith.ceildivui %b_div, %c_div : i64

    // Call to extended multiplication function
    %mul_low, %mul_high = call @muluiExtendedScalarConstants() : () -> (i8, i8)

    return %cmp_result, %vector_cmp_result, %div_result, %mul_low, %mul_high : i1, vector<4xi1>, i64, i8, i8
  }

  func.func @muluiExtendedScalarConstants() -> (i8, i8) {
    %c57 = arith.constant 57 : i8
    %c133 = arith.constant 133 : i8
    %low, %high = arith.mului_extended %c57, %c133: i8
    return %low, %high : i8, i8
  }
}