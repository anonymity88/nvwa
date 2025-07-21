module {
  func.func @get_bool_const() -> i1 {
    %bool_const = index.bool.constant true
    return %bool_const : i1
  }

  func.func @compute_min(%a: index, %b: index) -> index {
    %min_value = index.mins %a, %b
    return %min_value : index
  }

  func.func @compute_and(%a: index, %b: index) -> index {
    %result = index.and %a, %b
    return %result : index
  }

  func.func @main(%a: index, %b: index) -> (index, index, i1) {
    // Get boolean constant
    %bool_val = call @get_bool_const() : () -> i1
    
    // Compute minimum of inputs
    %min_result = call @compute_min(%a, %b) : (index, index) -> index
    
    // Compute AND of inputs
    %and_result = call @compute_and(%a, %b) : (index, index) -> index
    
    // Return all results
    return %min_result, %and_result, %bool_val : index, index, i1
  }
}