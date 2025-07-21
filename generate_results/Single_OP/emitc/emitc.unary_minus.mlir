module {
  emitc.func @main(%arg0 : i32) -> i32 {
    %0 = emitc.unary_minus %arg0 : (i32) -> i32
    emitc.return %0 : i32
  }
}