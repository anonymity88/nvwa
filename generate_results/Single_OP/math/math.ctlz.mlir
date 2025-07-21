module {
  func.func @main(%b: i32) -> i32 {
    %a = math.ctlz %b : i32
    return %a : i32
  }
}