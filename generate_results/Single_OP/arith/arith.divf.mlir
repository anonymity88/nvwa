module {
  func.func @main() -> f32 {
    // Create two floating-point values
    %0 = arith.constant 10.0 : f32
    %1 = arith.constant 2.0 : f32

    // Perform floating-point division
    %2 = arith.divf %0, %1 : f32

    // Return the result of the division
    return %2 : f32
  }
}