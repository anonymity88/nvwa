module {
  emitc.func @main(%arg0 : i32, %arg1 : i32) -> i32 {
    %0 = emitc.rem %arg0, %arg1 : (i32, i32) -> i32
    emitc.return %0 : i32
  }
}