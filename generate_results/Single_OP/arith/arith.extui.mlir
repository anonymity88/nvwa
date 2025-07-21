module {
  func.func @main() -> () {
    // Example usage of arith.extui operator
    %1 = arith.constant 5 : i3      // %1 is 0b101, a 3-bit integer
    %2 = arith.extui %1 : i3 to i6  // %2 is 0b000101, zero-extended to 6 bits
    %3 = arith.constant 2 : i3      // %3 is 0b010, another 3-bit integer
    %4 = arith.extui %3 : i3 to i6  // %4 is 0b000010, zero-extended to 6 bits

    // Example of extending from vector<2 x i32> to vector<2 x i64>
    %0 = arith.constant dense<[1, 2]> : vector<2 x i32> // A 2-element vector
    %5 = arith.extui %0 : vector<2 x i32> to vector<2 x i64> // Zero-extending each element

    // Return from the function
    return
  }
}