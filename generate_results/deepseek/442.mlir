module {
  func.func @main(%arg0: i32, %arg1: i32) -> (i32, i32) {
    // Bitwise operations
    %or_result = emitc.bitwise_or %arg0, %arg1 : (i32, i32) -> i32
    %xor_result = emitc.bitwise_xor %arg0, %arg1 : (i32, i32) -> i32
    %logical_and = emitc.logical_and %arg0, %arg1 : i32, i32
    
    // Convert boolean to integer
    %bool_as_int = arith.extui %logical_and : i1 to i32
    
    // Combine results
    %temp_result = arith.addi %or_result, %xor_result : i32
    %final_result = arith.addi %temp_result, %bool_as_int : i32
    
    // Call division function
    %div_result = call @div_int(%arg0, %arg1) : (i32, i32) -> i32
    
    return %final_result, %div_result : i32, i32
  }
  
  func.func @div_int(%arg0: i32, %arg1: i32) -> i32 {
    %result = "emitc.div"(%arg0, %arg1) : (i32, i32) -> i32
    return %result : i32
  }
}