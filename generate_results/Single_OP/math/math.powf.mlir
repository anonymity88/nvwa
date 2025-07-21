module {
  func.func @main(%b: f64, %c: f64) -> f64 {
    %a = math.powf %b, %c : f64
    return %a : f64
  }
}