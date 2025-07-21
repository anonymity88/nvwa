module {
  func.func @main(%b: f32, %c: f32) -> f32 {
    %a = math.copysign %b, %c : f32
    return %a : f32
  }
}