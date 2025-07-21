module {
  func.func @main(%b: i32) -> i32 {
    %a = math.cttz %b : i32
    return %a : i32
  }
}