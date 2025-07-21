module {
  func.func @main(%arg0 : i32) -> i32 {
    %0 = emitc.unary_plus %arg0 : (i32) -> i32
    return %0 : i32
  }
}