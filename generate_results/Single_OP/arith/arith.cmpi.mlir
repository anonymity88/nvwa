module {
  // Example for scalar "signed less than" comparison
  func.func @main() -> i1 {
    %lhs = arith.constant 5 : i32
    %rhs = arith.constant 10 : i32
    %result = arith.cmpi slt, %lhs, %rhs : i32
    return %result : i1
  }

  // Example for vector equality comparison
  func.func @main_vector() -> vector<4xi1> {
    %lhs = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %rhs = arith.constant dense<[1, 2, 3, 5]> : vector<4xi32>
    %result = arith.cmpi eq, %lhs, %rhs : vector<4xi32>
    return %result : vector<4xi1>
  }
}