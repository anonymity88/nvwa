module {
  func.func @main() -> () {
    %1 = arith.constant 21 : i5                  // %1 is 0b10101
    %2 = arith.trunci %1 : i5 to i4               // %2 is 0b0101
    %3 = arith.trunci %1 : i5 to i3               // %3 is 0b101

    %0 = arith.constant dense<[12, 12]> : vector<2 x i32>  // Vector constant of i32
    %4 = arith.trunci %0 : vector<2 x i32> to vector<2 x i16> // Truncating vector
    return
  }
}