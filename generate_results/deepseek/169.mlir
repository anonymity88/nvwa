module {
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

  func.func @select_value(%condition: i1, %trueValue: f32, %falseValue: f32) -> f32 {
    %result = scf.if %condition -> (f32) {
      scf.yield %trueValue : f32
    } else {
      scf.yield %falseValue : f32
    }
    return %result : f32
  }

  func.func @evaluate_condition(%arg: f32) -> i1 {
    %zero = arith.constant 0.0 : f32
    %cond = arith.cmpf "ogt", %arg, %zero : f32
    return %cond : i1
  }

  func.func @payload(%arg: f32) -> f32 {
    %one = arith.constant 1.0 : f32
    %incremented = arith.addf %arg, %one : f32
    return %incremented : f32
  }

  func.func @simple_while_loop(%init: f32) -> f32 {
    %res = scf.while (%arg1 = %init) : (f32) -> f32 {
      %condition = func.call @evaluate_condition(%arg1) : (f32) -> i1
      scf.condition(%condition) %arg1 : f32
    } do {
    ^bb0(%arg2: f32):
      %next = func.call @payload(%arg2) : (f32) -> f32
      scf.yield %next : f32
    }
    return %res : f32
  }

  func.func @main(%val0: i32, %cond: i1, %trueValue: f32, %falseValue: f32, %init: f32) 
      -> (i32, f32, f32) {
    %while_result = call @while_unused_arg2(%val0) : (i32) -> i32
    %select_result = call @select_value(%cond, %trueValue, %falseValue) : (i1, f32, f32) -> f32
    %loop_result = call @simple_while_loop(%init) : (f32) -> f32
    return %while_result, %select_result, %loop_result : i32, f32, f32
  }
}