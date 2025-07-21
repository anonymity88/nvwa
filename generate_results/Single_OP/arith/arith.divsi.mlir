module {
  func.func @main() -> i32 {
    %b = arith.constant 6 : i32
    %c = arith.constant -2 : i32
    %result = arith.divsi %b, %c : i32
    return %result : i32
  }
}