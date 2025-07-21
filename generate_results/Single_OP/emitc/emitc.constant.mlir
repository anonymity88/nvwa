module {
  // Integer constant example
  %0 = "emitc.constant"() {value = 42 : i32} : () -> i32

  // Constant emitted as `char = CHAR_MIN;`
  %1 = "emitc.constant"() {value = #emitc.opaque<"CHAR_MIN">} : () -> !emitc.opaque<"char">
}