module {
  func.func @main(%b: i64) -> i64 {
    %a = math.absi %b : i64
    return %a : i64
  }
}