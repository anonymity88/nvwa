module {
  func.func @main() -> () {
    // Defining two scalar signed integers for division.
    %b = arith.constant 5 : i64
    %c = arith.constant -2 : i64

    // Performing signed floor integer division.
    %result = arith.floordivsi %b, %c : i64

    // The result can be further used or returned from the function.
    return
  }
}