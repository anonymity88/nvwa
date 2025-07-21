module {
  func.func @max_unsigned_i64(%arg0: i64, %arg1: i64) -> i64 {
    %result = arith.maxui %arg0, %arg1 : i64
    return %result : i64
  }

  func.func @indexCastUIFoldSplatVector() -> vector<3xindex> {
    %cst = arith.constant dense<42> : vector<3xi32>
    %int = arith.index_castui %cst : vector<3xi32> to vector<3xindex>
    return %int : vector<3xindex>
  }

  func.func @main() -> (i1, vector<4xi1>, i8, vector<3xindex>) {
    // Integer comparisons
    %lhs_i32 = arith.constant 5 : i32
    %rhs_i32 = arith.constant 10 : i32
    %result_i1 = arith.cmpi slt, %lhs_i32, %rhs_i32 : i32

    // Vector comparisons
    %lhs_vec = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %rhs_vec = arith.constant dense<[1, 2, 3, 5]> : vector<4xi32>
    %result_vec = arith.cmpi eq, %lhs_vec, %rhs_vec : vector<4xi32>

    // Shift operations
    %val1_shift = arith.constant 160 : i8
    %val2_shift = arith.constant 3 : i8
    %result_shift = arith.shrui %val1_shift, %val2_shift : i8

    // Max unsigned call
    %max_arg0 = arith.extsi %lhs_i32 : i32 to i64
    %max_arg1 = arith.extsi %rhs_i32 : i32 to i64
    %max_result = call @max_unsigned_i64(%max_arg0, %max_arg1) : (i64, i64) -> i64

    // Index cast call
    %index_cast_result = call @indexCastUIFoldSplatVector() : () -> vector<3xindex>

    return %result_i1, %result_vec, %result_shift, %index_cast_result : i1, vector<4xi1>, i8, vector<3xindex>
  }
}