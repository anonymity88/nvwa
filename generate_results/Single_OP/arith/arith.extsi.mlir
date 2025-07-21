module {
  func.func @main() -> () {
    %1 = arith.constant 5 : i3      // %1 is 0b101 (3-bit integer)
    %2 = arith.extsi %1 : i3 to i6  // %2 is 0b111101 (6-bit integer)

    %3 = arith.constant 2 : i3      // %3 is 0b010 (3-bit integer)
    %4 = arith.extsi %3 : i3 to i6  // %4 is 0b000010 (6-bit integer)

    // Example with vectors
    %0 = arith.constant dense<[5, 2]> : vector<2 x i3> // A constant vector using 3-bit integers
    %5 = arith.extsi %0 : vector<2 x i3> to vector<2 x i64> // Extending to 64-bit integers
    return
  }
}