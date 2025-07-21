module {
  func.func @compute_ceildivu(%a: index, %b: index) -> index {
    %result = "index.ceildivu"(%a, %b) : (index, index) -> index
    return %result : index
  }

  func.func @compute_xor(%a: index, %b: index) -> index {
    %result = "index.xor"(%a, %b) : (index, index) -> index
    return %result : index
  }

  func.func @compute_ceildivs(%a: index, %b: index) -> index {
    %result = "index.ceildivs"(%a, %b) : (index, index) -> index
    return %result : index
  }

  func.func @xor() -> index {
    %lhs = index.constant 5
    %rhs = index.constant 1
    %0 = index.xor %lhs, %rhs
    return %0 : index
  }

  func.func @main(%a: index, %b: index) -> (index, index, index, index) {
    %ceildivu = call @compute_ceildivu(%a, %b) : (index, index) -> index
    %xor = call @compute_xor(%a, %b) : (index, index) -> index
    %ceildivs = call @compute_ceildivs(%a, %b) : (index, index) -> index
    %xor_const = call @xor() : () -> index
    return %ceildivu, %xor, %ceildivs, %xor_const : index, index, index, index
  }
}