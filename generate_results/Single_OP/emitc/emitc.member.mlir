module {
  func.func @main(%arg0: !emitc.lvalue<!emitc.opaque<"mystruct">>) -> i32 {
    %0 = "emitc.member"(%arg0) {member = "a"} 
        : (!emitc.lvalue<!emitc.opaque<"mystruct">>) -> !emitc.lvalue<i32>
    %1 = "emitc.load"(%0) : (!emitc.lvalue<i32>) -> i32
    return %1 : i32
  }
}