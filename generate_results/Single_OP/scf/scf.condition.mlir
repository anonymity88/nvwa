func.func @while_unused_arg2(%val0: i32) -> i32 {
  %0 = scf.while (%val1 = %val0) : (i32) -> i32 {
    %val = "test.val"() : () -> i32
    %condition = "test.condition"() : () -> i1
    scf.condition(%condition) %val: i32
  } do {
  ^bb0(%val2: i32):
    "test.use"(%val2) : (i32) -> ()
    %val1 = "test.val1"() : () -> i32
    scf.yield %val1 : i32
  }
  return %0 : i32
}