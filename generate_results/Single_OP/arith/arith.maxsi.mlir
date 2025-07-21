module {
  func.func @main() {
    // Define two signed integer constants
    %0 = arith.constant 5 : i32
    %1 = arith.constant 10 : i32
    
    // Use arith.maxsi to compute the maximum
    %result = arith.maxsi %0, %1 : i32

    // Terminate the function
    return
  }
}