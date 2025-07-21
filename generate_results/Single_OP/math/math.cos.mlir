module {
  func.func @main(%b: f64) -> f64 {
    %a = math.cos %b : f64
    return %a : f64
  }
}