module {
  func.func @main() -> i32 {
    // Defining constants directly as integer literals
    %a = arith.constant 1 : i32
    %b = arith.constant 2 : i32
    %c = arith.constant 3 : i32
    %d = arith.constant 4 : i32
    
    // Use the emitc.expression operator to compute an expression
    %r = emitc.expression : i32 {
      %0 = emitc.add %a, %b : (i32, i32) -> i32
      %1 = emitc.call_opaque "foo"(%0) : (i32) -> i32
      %2 = emitc.add %c, %d : (i32, i32) -> i32
      %3 = emitc.mul %1, %2 : (i32, i32) -> i32
      emitc.yield %3 : i32
    }
    
    // Returning the result of the emitc.expression
    return %r : i32
  }
}