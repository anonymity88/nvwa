module {
  func.func @main() -> i32 {
    %b = arith.constant 5 : i32         // Example scalar constant
    %c = arith.constant 3 : i32         // Example scalar constant
    %result = arith.andi %b, %c : i32   // Scalar integer bitwise and
    return %result : i32
  }
}