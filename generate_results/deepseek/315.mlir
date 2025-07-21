module {
  func.func @main() -> (i32, f64, vector<3xi32>) {
    // Integer operations
    %1 = arith.constant 5 : i3
    %2 = arith.extui %1 : i3 to i6
    %3 = arith.constant 2 : i3
    %4 = arith.extui %3 : i3 to i6
    
    // Vector extension
    %0 = arith.constant dense<[1, 2]> : vector<2xi32>
    %5 = arith.extui %0 : vector<2xi32> to vector<2xi64>
    
    // Bitwise AND
    %b_and = arith.constant 5 : i32
    %c_and = arith.constant 3 : i32
    %result_and = arith.andi %b_and, %c_and : i32
    
    // Floating-point addition
    %b_add = arith.constant 3.5 : f64
    %c_add = arith.constant 2.5 : f64
    %result_add = arith.addf %b_add, %c_add : f64
    
    // Prepare inputs for wideMulToMulSIExtendedVector
    %a_vec = arith.constant dense<[1, 2, 3]> : vector<3xi32>
    %b_vec = arith.constant dense<[4, 5, 6]> : vector<3xi32>
    
    // Call the wide multiplication function
    %mul_result = call @wideMulToMulSIExtendedVector(%a_vec, %b_vec) : (vector<3xi32>, vector<3xi32>) -> vector<3xi32>
    
    return %result_and, %result_add, %mul_result : i32, f64, vector<3xi32>
  }

  func.func @wideMulToMulSIExtendedVector(%a: vector<3xi32>, %b: vector<3xi32>) -> vector<3xi32> {
    %x = arith.extsi %a: vector<3xi32> to vector<3xi64>
    %y = arith.extsi %b: vector<3xi32> to vector<3xi64>
    %m = arith.muli %x, %y: vector<3xi64>
    %c32 = arith.constant dense<32>: vector<3xi64>
    %sh = arith.shrui %m, %c32 : vector<3xi64>
    %hi = arith.trunci %sh: vector<3xi64> to vector<3xi32>
    return %hi : vector<3xi32>
  }
}