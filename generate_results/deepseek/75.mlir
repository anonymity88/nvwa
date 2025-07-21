module {
  // Include C++ extern C guards
  func.func @emit_cpp_guards() {
    "emitc.verbatim"() {value = "#ifdef __cplusplus\nextern \"C\" {\n#endif\n"} : () -> ()
    "emitc.verbatim"() {value = "#ifdef __cplusplus\n}\n#endif\n"} : () -> ()
    return
  }

  // Function to perform bitwise XOR
  func.func @bitwise_xor(%arg0: i32, %arg1: i32) -> i32 {
    %result = emitc.bitwise_xor %arg0, %arg1 : (i32, i32) -> i32
    return %result : i32
  }

  // Function to perform floating-point addition
  emitc.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %result = emitc.add %arg0, %arg1 : (f32, f32) -> f32
    emitc.return %result : f32
  }

  // Main function demonstrating all operations
  func.func @main(%arg0: i32, %arg1: i32, %arg2: f32, %arg3: f32) -> (i32, f32) {
    // Emit C++ guards
    call @emit_cpp_guards() : () -> ()
    
    // Perform bitwise XOR
    %xor_result = call @bitwise_xor(%arg0, %arg1) : (i32, i32) -> i32
    
    // Perform floating-point addition
    %add_result = emitc.call @my_add(%arg2, %arg3) : (f32, f32) -> f32
    
    // Return both results
    return %xor_result, %add_result : i32, f32
  }
}