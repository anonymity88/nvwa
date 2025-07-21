module {
  func.func @compute_sub(%a: index, %b: index) -> index {
    %result = "index.sub"(%a, %b) : (index, index) -> index
    return %result : index
  }

  func.func @compute_max(%a: index, %b: index) -> index {
    %max_val = "index.maxu"(%a, %b) : (index, index) -> index
    return %max_val : index
  }

  func.func @compute_mul(%a: index, %b: index) -> index {
    %product = "index.mul"(%a, %b) : (index, index) -> index
    return %product : index
  }

  func.func @main(%a: index, %b: index) -> (index, index, index) {
    // Compute subtraction
    %sub_result = call @compute_sub(%a, %b) : (index, index) -> index
    
    // Compute maximum
    %max_result = call @compute_max(%a, %b) : (index, index) -> index
    
    // Compute multiplication
    %mul_result = call @compute_mul(%a, %b) : (index, index) -> index
    
    // Return all three results
    return %sub_result, %max_result, %mul_result : index, index, index
  }
}