module {
  func.func @main() -> f32 {
    %value = arith.constant 42 : i32
    %result = arith.sitofp %value : i32 to f32
    return %result : f32
  }
}