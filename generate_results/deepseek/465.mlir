module {
  func.func @main() -> (index, i32) {
    %0 = call @ub() : () -> index
    %1 = call @poison_full_form() : () -> i32
    return %0, %1 : index, i32
  }
  func.func @ub() -> index {
    %0 = ub.poison : index
    return %0 : index
  }
  func.func @poison_full_form() -> i32 {
    %0 = ub.poison <#ub.poison> : i32
    return %0 : i32
  }
}