module {
  func.func @main(%arg0: !emitc.lvalue<i32>) -> i32 {
    %1 = emitc.load %arg0 : !emitc.lvalue<i32>
    return %1 : i32
  }
}