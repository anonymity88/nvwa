module {
  func.func @main(%arg0 : !emitc.lvalue<!emitc.ptr<!emitc.opaque<"mystruct">>>) -> !emitc.lvalue<i32> {
    %0 = "emitc.member_of_ptr"(%arg0) {member = "a"} : (!emitc.lvalue<!emitc.ptr<!emitc.opaque<"mystruct">>>) -> !emitc.lvalue<i32>
    return %0 : !emitc.lvalue<i32>
  }
}