module {
  func.func @main() -> () {
    %1 = arith.constant 3.14 : f64  // Define a constant of type f64
    %0 = arith.truncf %1 : f64 to f32 // Use truncf to convert f64 to f32
    return
  }
}