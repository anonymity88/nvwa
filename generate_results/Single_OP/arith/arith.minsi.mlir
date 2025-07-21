module {
  func.func @min_example(%arg0: i32, %arg1: i32) -> i32 {
    %result = arith.minsi %arg0, %arg1 : i32
    return %result : i32
  }
}