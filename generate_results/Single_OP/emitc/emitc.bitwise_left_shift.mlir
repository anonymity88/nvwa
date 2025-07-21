module {
  func.func @main(%arg0 : i32, %arg1 : i32) -> i32 {
    %0 = emitc.bitwise_left_shift %arg0, %arg1 : (i32, i32) -> i32
    return %0 : i32
  }
}