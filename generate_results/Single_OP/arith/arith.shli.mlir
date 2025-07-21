module {
  // Define a function to demonstrate the shli operator
  func.func @example_shli() -> () {
    // Create a constant integer value of 5 (0b00000101) of type i8
    %1 = arith.constant 5 : i8
    // Create a constant integer value of 3 (the number of bits to shift) of type i8
    %2 = arith.constant 3 : i8
    // Perform left shift operation on %1 by %2
    %3 = arith.shli %1, %2 : i8
    // Perform left shift operation with overflow flags
    %4 = arith.shli %1, %2 overflow<nsw, nuw> : i8

    // Return from the function
    return
  }
}