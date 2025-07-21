module {
  %0 = "emitc.variable"() {value = 42 : i32} : () -> !emitc.lvalue<i32>
  %1 = "emitc.variable"() {value = #emitc.opaque<"NULL">} 
    : () -> !emitc.lvalue<!emitc.ptr<!emitc.opaque<"int32_t">>>
  %2 = "emitc.variable"() {value = 0 : i32} : () -> !emitc.lvalue<i32>
  %3 = "emitc.variable"() {value = 0 : i32} : () -> !emitc.lvalue<i32>
  %4 = emitc.apply "&"(%2) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>
  %5 = emitc.apply "&"(%3) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>
  emitc.call_opaque "write"(%4, %5)
    : (!emitc.ptr<i32>, !emitc.ptr<i32>) -> ()
}