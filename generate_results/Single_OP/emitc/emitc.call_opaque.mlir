module {
  emitc.func @example() -> i32 {
    %result = emitc.call_opaque "foo"() : () -> i32
    emitc.return %result : i32
  }
}