module {
  // Function to demonstrate the use of arith.minui
  func.func @minui_example(%a: i32, %b: i32) -> i32 {
    %result = arith.minui %a, %b : i32
    return %result : i32
  }
}