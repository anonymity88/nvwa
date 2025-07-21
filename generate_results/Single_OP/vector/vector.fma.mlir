module {
  func.func @main() {
    // Define the input vectors for the fma operation
    %lhs = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>
    %rhs = arith.constant dense<[[2.0, 3.0], [4.0, 5.0], [6.0, 7.0], [8.0, 9.0]]> : vector<4x2xf32>
    %acc = arith.constant dense<[[1.0, 1.0], [1.0, 1.0], [1.0, 1.0], [1.0, 1.0]]> : vector<4x2xf32>

    // Perform the vector fused multiply-add operation
    %result = vector.fma %lhs, %rhs, %acc : vector<4x2xf32>

    return
  }
}