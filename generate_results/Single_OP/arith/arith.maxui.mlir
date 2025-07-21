module {
  func.func @max_unsigned_i64(%arg0: i64, %arg1: i64) -> i64 {
    %result = arith.maxui %arg0, %arg1 : i64
    return %result : i64
  }
}