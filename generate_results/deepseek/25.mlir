module {
  func.func @main() -> (i32, i8) {
    // Truncation operations
    %1 = arith.constant 21 : i5                  // %1 is 0b10101
    %2 = arith.trunci %1 : i5 to i4             // %2 is 0b0101
    %3 = arith.trunci %1 : i5 to i3             // %3 is 0b101

    // Vector truncation
    %0 = arith.constant dense<[12, 12]> : vector<2 x i32>
    %4 = arith.trunci %0 : vector<2 x i32> to vector<2 x i16>

    // Shift left operations (call to example_shli)
    %shli_result = call @example_shli() : () -> i8

    // Maximum operation
    %max_val1 = arith.constant 5 : i32
    %max_val2 = arith.constant 10 : i32
    %max_result = arith.maxsi %max_val1, %max_val2 : i32

    // Return both the maximum result and shift left result
    return %max_result, %shli_result : i32, i8
  }

  func.func @example_shli() -> i8 {
    %1 = arith.constant 5 : i8
    %2 = arith.constant 3 : i8
    %3 = arith.shli %1, %2 : i8
    %4 = arith.shli %1, %2 overflow<nsw, nuw> : i8

    // Return one of the shift results
    return %3 : i8
  }
}