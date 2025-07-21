module {
  func.func @main() {
    // Allocate memory for the left-hand side (LHS) matrix
    %A = memref.alloc() : memref<64xf64>

    // Allocate memory for the right-hand side (RHS) matrix
    %B = memref.alloc() : memref<48xf64>

    // Perform the vector matrix multiplication operation
    %C = vector.matrix_multiply %A, %B
        { lhs_rows = 4 : i32, lhs_columns = 16 : i32, rhs_columns = 3 : i32 } :
        (vector<64xf64>, vector<48xf64>) -> vector<12xf64>

    return
  }
}