module {
  func.func @main() -> f32 {
    %0 = arith.constant 42 : i32
    %1 = arith.uitofp %0 : i32 to f32
    return %1 : f32
  }
}