func.func @poison() -> i32 {
  %0 = ub.poison : i32
  return %0 : i32
}