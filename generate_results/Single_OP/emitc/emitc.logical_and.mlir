module {
  func.func @main(%arg0: i32, %arg1: i32) -> i1 {
    %0 = emitc.logical_and %arg0, %arg1 : i32, i32
    return %0 : i1
  }
}