module {
  func.func @main(%b: f64) -> f64 {
    %a = math.tan %b : f64
    return %a : f64
  }
}