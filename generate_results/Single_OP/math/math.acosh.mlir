module {
  func.func @main(%b: f64) -> f64 {
    %a = math.acosh %b : f64
    return %a : f64
  }
}