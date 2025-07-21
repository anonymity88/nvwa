module {
  func.func @main(%base: f64, %power: i32) -> f64 {
    %result = math.fpowi %base, %power : f64, i32
    return %result : f64
  }
}