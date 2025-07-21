module {
  func.func @main(%b: i32, %c: i32) -> i32 {
    %a = math.ipowi %b, %c : i32
    return %a : i32
  }
}