module {
  func.func @main(%a: f64, %b: f64, %c: f64) -> f64 {
    %d = math.fma %a, %b, %c : f64
    return %d : f64
  }
}