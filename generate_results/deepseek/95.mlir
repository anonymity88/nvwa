module {
  func.func @compute_minu(%a: index, %b: index) -> index {
    %min_val = "index.minu"(%a, %b) : (index, index) -> index
    return %min_val : index
  }

  func.func @compute_sub(%a: index, %b: index) -> index {
    %sub_val = "index.sub"(%a, %b) : (index, index) -> index
    return %sub_val : index
  }

  func.func @compute_or(%a: index, %b: index) -> index {
    %or_val = "index.or"(%a, %b) : (index, index) -> index
    return %or_val : index
  }

  func.func @main(%a: index, %b: index) -> index {
    // Compute minimum unsigned value
    %min_result = call @compute_minu(%a, %b) : (index, index) -> index
    
    // Compute subtraction
    %sub_result = call @compute_sub(%a, %b) : (index, index) -> index
    
    // Compute bitwise OR
    %or_result = call @compute_or(%a, %b) : (index, index) -> index
    
    // For demonstration, return the OR of all results
    %final_or1 = "index.or"(%min_result, %sub_result) : (index, index) -> index
    %final_result = "index.or"(%final_or1, %or_result) : (index, index) -> index
    
    return %final_result : index
  }
}