module {
  // Include necessary headers
  emitc.include "myheader.h" : () -> ()

  // Function to perform i32 to f32 cast
  func.func @cast_func(%arg0: i32) -> f32 {
    %0 = emitc.cast %arg0 : i32 to f32
    return %0 : f32
  }

  // Function to perform bitwise OR operation
  func.func @bitwise_or_func(%arg0: i32, %arg1: i32) -> i32 {
    %0 = emitc.bitwise_or %arg0, %arg1 : (i32, i32) -> i32
    return %0 : i32
  }

  // Main function that combines all operations
  func.func @main() -> f32 {
    // Constants for expression
    %a = arith.constant 1 : i32
    %b = arith.constant 2 : i32
    %c = arith.constant 3 : i32
    %d = arith.constant 4 : i32
    
    // Complex expression computation
    %r = emitc.expression : i32 {
      %0 = emitc.add %a, %b : (i32, i32) -> i32
      %1 = emitc.call_opaque "foo"(%0) : (i32) -> i32
      %2 = emitc.add %c, %d : (i32, i32) -> i32
      %3 = emitc.mul %1, %2 : (i32, i32) -> i32
      emitc.yield %3 : i32
    }
    
    // Perform bitwise OR on some constants
    %or_result = func.call @bitwise_or_func(%a, %b) : (i32, i32) -> i32
    
    // Combine results from expression and bitwise OR
    %combined = emitc.add %r, %or_result : (i32, i32) -> i32
    
    // Cast the final result to f32
    %final_result = func.call @cast_func(%combined) : (i32) -> f32
    
    // Return the final result
    return %final_result : f32
  }
}