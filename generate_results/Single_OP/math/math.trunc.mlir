module {
  func.func @main(%b: f64) -> f64 {
    %a = math.trunc %b : f64
    return %a : f64
  }
}