module {
  func.func @main() -> i32 {
    // Integer constant
    %1 = arith.constant 42 : i32

    // Floating-point constant
    %2 = arith.constant 3.14 : f32

    // Returning an integer constant for demonstration
    return %1 : i32
  }
}