module {
  func.func @main(%arg0: i32, %arg1: i32, %arg2: i1, %arg3: f32) -> i32 {
    // Bitwise operations from first function
    %unary_minus = emitc.unary_minus %arg0 : (i32) -> i32
    %bitwise_and = emitc.bitwise_and %arg0, %arg1 : (i32, i32) -> i32
    %bitwise_xor = emitc.bitwise_xor %arg0, %arg1 : (i32, i32) -> i32
    
    // Combine operations
    %sum = emitc.add %unary_minus, %bitwise_and : (i32, i32) -> i32
    %final_result = emitc.bitwise_xor %sum, %bitwise_xor : (i32, i32) -> i32
    
    // Call conditional function
    call @test_if_else(%arg2, %arg3) : (i1, f32) -> ()
    
    return %final_result : i32
  }

  func.func @test_if_else(%arg0: i1, %arg1: f32) {
    // Conditional operation with proper syntax
    emitc.if %arg0 {
      %0 = emitc.call_opaque "func_true"(%arg1) : (f32) -> i32
    } else {
      %0 = emitc.call_opaque "func_false"(%arg1) : (f32) -> i32
    }
    return
  }
}