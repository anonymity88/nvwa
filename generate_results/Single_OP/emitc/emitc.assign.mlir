module {
  %0 = "emitc.variable"() {value = 42 : i32} : () -> !emitc.lvalue<i32>
  %1 = "emitc.call_opaque"() {callee = "foo"} : () -> i32

  // Correction: Swap %0 and %1 positions and fix types
  emitc.assign %1 : i32 to %0 : !emitc.lvalue<i32>
}