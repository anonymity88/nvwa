module {
  func.func @main(%y: f64, %x: f64) -> f64 {
    %angle = math.atan2 %y, %x : f64
    return %angle : f64
  }
}