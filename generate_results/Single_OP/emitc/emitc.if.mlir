module {
  func.func @example(%cond: i1) -> () {
    emitc.if %cond {
      // Code executed if condition is true
      emitc.include "then_header.h" : () -> ()
      emitc.yield
    } else {
      // Code executed if condition is false
      emitc.include "else_header.h" : () -> ()
      emitc.yield
    }
    return
  }
}