module {
  ml_program.func @compute_sum(%arg0: i32, %arg1: i32) -> i32 {
    // Add the two integer arguments
    %sum = arith.addi %arg0, %arg1 : i32
    
    // Return the result of the addition
    ml_program.return %sum : i32
  }
}