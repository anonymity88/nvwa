module {
  func.func @while_unused_arg1(%x : i32, %y : f64) -> i32 {
    %0 = scf.while (%arg1 = %x, %arg2 = %y) : (i32, f64) -> (i32) {
      %condition = "test.condition"(%arg1) : (i32) -> i1
      scf.condition(%condition) %arg1 : i32
    } do {
    ^bb0(%arg1: i32):
      %next = "test.use"(%arg1) : (i32) -> (i32)
      scf.yield %next, %y : i32, f64
    }
    return %0 : i32
  }

  func.func @main(%a: i32, %b: i32, %flag: i1, %cond: i1, %switch_flag: i32, %while_x: i32, %while_y: f64) -> (i32, i32) {
    cf.assert %cond, "The condition was expected to be true, but it was false."
    
    cf.switch %switch_flag : i32, [
      default: ^bb4,
      0: ^bb2,
      1: ^bb3
    ]

    ^bb2:  // case 0
      cf.br ^bb5(%a : i32)
    
    ^bb3:  // case 1
      cf.br ^bb5(%b : i32)
    
    ^bb4:  // default case
      cf.br ^bb5(%a : i32)
    
    ^bb5(%switch_result: i32):
      cf.cond_br %flag, ^bb6(%a : i32), ^bb7(%b : i32)
    
    ^bb6(%x: i32):
      %while_result = call @while_unused_arg1(%while_x, %while_y) : (i32, f64) -> i32
      return %x, %while_result : i32, i32
    
    ^bb7(%y: i32):
      %while_result2 = call @while_unused_arg1(%while_x, %while_y) : (i32, f64) -> i32
      return %y, %while_result2 : i32, i32
  }
}