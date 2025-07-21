module {
  // Function that takes two floating-point inputs and returns their remainder
  func.func @computeRemainder(%0: f32, %1: f32) -> f32 {
    // Compute the remainder of %0 divided by %1
    %result = arith.remf %0, %1 : f32

    // Return the result
    return %result : f32
  }
}