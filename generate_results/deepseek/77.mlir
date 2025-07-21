module {
  func.func @main(%arg0: i32, %arg1: i32) -> i32 {
    // Compute unary minus of first argument
    %unary_minus = emitc.unary_minus %arg0 : (i32) -> i32
    
    // Compute bitwise AND of both arguments
    %bitwise_and = emitc.bitwise_and %arg0, %arg1 : (i32, i32) -> i32
    
    // Compute bitwise XOR of both arguments
    %bitwise_xor = emitc.bitwise_xor %arg0, %arg1 : (i32, i32) -> i32
    
    // Combine results: (unary_minus + bitwise_and) XOR bitwise_xor
    %sum = emitc.add %unary_minus, %bitwise_and : (i32, i32) -> i32
    %final_result = emitc.bitwise_xor %sum, %bitwise_xor : (i32, i32) -> i32
    
    return %final_result : i32
  }
}