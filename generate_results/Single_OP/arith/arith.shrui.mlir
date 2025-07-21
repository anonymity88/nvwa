module {
  func.func @main() -> i8 {
    %1 = arith.constant 160 : i8               // %1 is 0b10100000
    %2 = arith.constant 3 : i8
    %3 = arith.shrui %1, %2 : i8                // %3 is 0b00010100
    return %3 : i8
  }
}