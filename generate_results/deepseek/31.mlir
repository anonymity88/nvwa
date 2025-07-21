module {
  func.func @main() -> (i32, f64) {
    // Integer extension operations
    %1 = arith.constant 5 : i3
    %2 = arith.extui %1 : i3 to i6
    %3 = arith.constant 2 : i3
    %4 = arith.extui %3 : i3 to i6
    
    // Vector extension operation
    %0 = arith.constant dense<[1, 2]> : vector<2xi32>
    %5 = arith.extui %0 : vector<2xi32> to vector<2xi64>
    
    // Bitwise AND operation
    %b_and = arith.constant 5 : i32
    %c_and = arith.constant 3 : i32
    %result_and = arith.andi %b_and, %c_and : i32
    
    // Floating-point addition
    %b_add = arith.constant 3.5 : f64
    %c_add = arith.constant 2.5 : f64
    %result_add = arith.addf %b_add, %c_add : f64
    
    // Return both the AND result and addition result
    return %result_and, %result_add : i32, f64
  }
}