module {
  func.func @main() -> i64 {
    %b = arith.constant 6 : i64
    %c = arith.constant 2 : i64
    %result = arith.remui %b, %c : i64
    return %result : i64
  }
}