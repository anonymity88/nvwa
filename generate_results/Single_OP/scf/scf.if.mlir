module {
  func.func @select_value(%condition: i1, %trueValue: f32, %falseValue: f32) -> f32 {
    // Use scf.if to make a selection based on the condition
    %result = scf.if %condition -> (f32) {
      // If condition is true, yield the trueValue
      scf.yield %trueValue : f32
    } else {
      // If condition is false, yield the falseValue
      scf.yield %falseValue : f32
    }

    return %result : f32
  }
}