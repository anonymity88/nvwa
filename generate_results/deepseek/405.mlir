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

  func.func @maxs_nofold() -> index {
    %lhs = index.constant 1
    %rhs = index.constant 0x100000000
    %0 = index.maxs %lhs, %rhs
    return %0 : index
  }

  func.func @main(%a: index, %b: index) -> (index, index, index, index) {
    %sub_result = call @compute_sub(%a, %b) : (index, index) -> index
    %max_result = call @compute_max(%a, %b) : (index, index) -> index
    %mul_result = call @compute_mul(%a, %b) : (index, index) -> index
    %maxs_result = call @maxs_nofold() : () -> index
    return %sub_result, %max_result, %mul_result, %maxs_result : index, index, index, index
  }
}