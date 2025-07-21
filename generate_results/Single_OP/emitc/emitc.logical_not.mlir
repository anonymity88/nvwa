module {
  func.func @main(%arg0 : i32) -> i1 {
    %0 = emitc.logical_not %arg0 : i32
    return %0 : i1
  }
}