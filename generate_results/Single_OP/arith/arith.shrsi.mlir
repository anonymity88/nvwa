module {
  func.func @main() -> i8 {
    %c160_i8 = arith.constant 160 : i8          // %c160_i8 is 0b10100000
    %c3_i8 = arith.constant 3 : i8
    %result1 = arith.shrsi %c160_i8, %c3_i8 : i8 // %result1 is 0b11110100
    %c96_i8 = arith.constant 96 : i8            // %c96_i8 is 0b01100000
    %result2 = arith.shrsi %c96_i8, %c3_i8 : i8  // %result2 is 0b00001100
    return %result1 : i8
  }
}