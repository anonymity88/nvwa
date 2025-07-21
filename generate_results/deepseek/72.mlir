// Include necessary header
emitc.include "myheader.h" : () -> ()

module {
  func.func @bitwise_not_wrapper(%arg0: i32) -> i32 {
    %0 = emitc.bitwise_not %arg0 : (i32) -> i32
    return %0 : i32
  }

  func.func @main(%arg0: i32, %arg1: i32) -> i32 {
    // Compare the two arguments
    %cmp_result = emitc.cmp "gt", %arg0, %arg1 : (i32, i32) -> i1

    // Constants for conditional selection
    %c10 = arith.constant 10 : i32
    %c11 = arith.constant 11 : i32

    // Select between constants based on comparison
    %selected = emitc.conditional %cmp_result, %c10, %c11 : i32

    // Apply bitwise not to the selected value
    %bitwise_not_result = call @bitwise_not_wrapper(%selected) : (i32) -> i32

    // Return the final result
    return %bitwise_not_result : i32
  }
}