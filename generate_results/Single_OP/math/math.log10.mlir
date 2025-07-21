module {
  func.func @main(%x: f64) -> f64 {
    %y = math.log10 %x : f64
    return %y : f64
  }
}