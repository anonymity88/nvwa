module {
  func.func @main(%condition: i1, %true_value: i32, %false_value: i32) -> i32 {
    spirv.BranchConditional %condition, ^true_branch, ^false_branch

  ^true_branch:
    return %true_value : i32

  ^false_branch:
    return %false_value : i32
  }
}