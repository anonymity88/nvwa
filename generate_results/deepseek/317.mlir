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

  func.func @mins_nofold_2() -> index {
    %lhs = index.constant 0x7fffffff
    %rhs = index.constant 0x80000000
    %0 = index.mins %lhs, %rhs
    return %0 : index
  }

  func.func @main(%input1: index, %input2: index) -> (index, index, index, index) {
    %ceil_result = call @ceildiv_operation(%input1, %input2) : (index, index) -> index
    
    %remu_result = call @remu_operation(%input1, %input2) : (index, index) -> index
    
    %xor_result = call @xor_operation(%ceil_result, %remu_result) : (index, index) -> index
    
    %mins_result = call @mins_nofold_2() : () -> index
    
    return %ceil_result, %remu_result, %xor_result, %mins_result : index, index, index, index
  }
}