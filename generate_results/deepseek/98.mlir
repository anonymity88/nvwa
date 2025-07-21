module {
  func.func @ceildiv_operation(%a: index, %b: index) -> index {
    %c = index.ceildivs %a, %b
    return %c : index
  }

  func.func @remu_operation(%a: index, %b: index) -> index {
    %result = index.remu %a, %b
    return %result : index
  }

  func.func @xor_operation(%a: index, %b: index) -> index {
    %c = index.xor %a, %b
    return %c : index
  }

  func.func @main(%input1: index, %input2: index) -> (index, index, index) {
    // First compute ceiling division
    %ceil_result = call @ceildiv_operation(%input1, %input2) : (index, index) -> index
    
    // Then compute unsigned remainder using the same inputs
    %remu_result = call @remu_operation(%input1, %input2) : (index, index) -> index
    
    // Finally compute XOR operation using the previous results
    %xor_result = call @xor_operation(%ceil_result, %remu_result) : (index, index) -> index
    
    // Return all three results
    return %ceil_result, %remu_result, %xor_result : index, index, index
  }
}