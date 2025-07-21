module {
  func.func @main(%b: f64) -> f64 {
    %a = math.roundeven %b : f64
    return %a : f64
  }
}