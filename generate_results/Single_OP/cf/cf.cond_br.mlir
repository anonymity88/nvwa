module {
  func.func @main(%a: i32, %b: i32, %flag: i1) -> i32 {
    // Conditional branch based on %flag
    cf.cond_br %flag, ^bb1(%a : i32), ^bb2(%b : i32)

  ^bb1(%x : i32):
    // Return the first operand if condition is true
    return %x : i32

  ^bb2(%y : i32):
    // Return the second operand if condition is false
    return %y : i32
  }
}