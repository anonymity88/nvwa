module {
  func.func @main(%arg0: !emitc.lvalue<i32>) -> !emitc.ptr<i32> {
    %0 = emitc.apply "&"(%arg0) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>
    return %0 : !emitc.ptr<i32>
  }
}