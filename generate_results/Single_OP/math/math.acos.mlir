module {
  func.func @main(%b: f64) -> f64 {
    %a = math.acos %b : f64
    return %a : f64
  }
}