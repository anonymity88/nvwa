module {
  func.func @main(%arg0: i32, %arg1: i32) -> i32 {
    // Perform bitwise OR operation
    %or_result = emitc.bitwise_or %arg0, %arg1 : (i32, i32) -> i32
    
    // Perform bitwise XOR operation
    %xor_result = emitc.bitwise_xor %arg0, %arg1 : (i32, i32) -> i32
    
    // Perform logical AND operation (converting i32 to i1)
    %logical_and = emitc.logical_and %arg0, %arg1 : i32, i32
    
    // Convert the boolean result back to i32 for consistency
    %bool_as_int = arith.extui %logical_and : i1 to i32
    
    // Combine all results
    %temp_result = arith.addi %or_result, %xor_result : i32
    %final_result = arith.addi %temp_result, %bool_as_int : i32
    
    return %final_result : i32
  }
}