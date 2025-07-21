module {
  func.func @main() -> i64 {
    // Define the inputs for the ceildivsi operation.
    %b = arith.constant 7 : i64
    %c = arith.constant -2 : i64

    // Perform signed ceil integer division.
    %result = arith.ceildivsi %b, %c : i64

    // Returning the result
    return %result : i64
  }
}