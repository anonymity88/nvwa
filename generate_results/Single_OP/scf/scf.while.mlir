module {
  func.func @simple_while_loop(%init: f32) -> f32 {
    %res = scf.while (%arg1 = %init) : (f32) -> f32 {
      // "Before" region: Compute the condition and perform computation
      %condition = func.call @evaluate_condition(%arg1) : (f32) -> i1
      scf.condition(%condition) %arg1 : f32
    } do {
    ^bb0(%arg2: f32):
      // "After" region: Execute loop payload and prepare for next iteration
      %next = func.call @payload(%arg2) : (f32) -> f32
      scf.yield %next : f32
    }

    return %res : f32
  }

  func.func @evaluate_condition(%arg: f32) -> i1 {
    // Example condition: return true if arg is greater than zero
    %zero = arith.constant 0.0 : f32
    %cond = arith.cmpf "ogt", %arg, %zero : f32
    return %cond : i1
  }

  func.func @payload(%arg: f32) -> f32 {
    // Example payload: increment the argument
    %one = arith.constant 1.0 : f32
    %incremented = arith.addf %arg, %one : f32
    return %incremented : f32
  }
}