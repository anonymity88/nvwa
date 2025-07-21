module {
  func.func @get_constant() -> index {
    %c = index.constant 42
    return %c : index
  }

  func.func @compute_remainder(%a: index, %b: index) -> index {
    %rem = index.rems %a, %b
    return %rem : index
  }

  func.func @main(%a: index, %b: index) -> index {
    // Get the constant value
    %constant = call @get_constant() : () -> index
    
    // Compute remainder using input arguments
    %remainder = call @compute_remainder(%a, %b) : (index, index) -> index
    
    // Shift right the remainder result by b positions
    %result = index.shrs %remainder, %b
    
    return %result : index
  }
}