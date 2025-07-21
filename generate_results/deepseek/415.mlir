module {
  func.func @emit_cpp_guards() {
    "emitc.verbatim"() {value = "#ifdef __cplusplus\nextern \"C\" {\n#endif\n"} : () -> ()
    "emitc.verbatim"() {value = "#ifdef __cplusplus\n}\n#endif\n"} : () -> ()
    return
  }

  func.func @bitwise_xor(%arg0: i32, %arg1: i32) -> i32 {
    %result = emitc.bitwise_xor %arg0, %arg1 : (i32, i32) -> i32
    return %result : i32
  }

  emitc.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %result = emitc.add %arg0, %arg1 : (f32, f32) -> f32
    emitc.return %result : f32
  }

  func.func @sub_int(%arg0: i32, %arg1: i32) -> i32 {
    %result = "emitc.sub" (%arg0, %arg1) : (i32, i32) -> i32
    return %result : i32
  }

  func.func @main(%arg0: i32, %arg1: i32, %arg2: f32, %arg3: f32) -> (i32, f32, i32) {
    // Call C++ guards function
    call @emit_cpp_guards() : () -> ()
    
    // Call bitwise XOR operation
    %xor_result = call @bitwise_xor(%arg0, %arg1) : (i32, i32) -> i32
    
    // Call floating-point addition
    %add_result = emitc.call @my_add(%arg2, %arg3) : (f32, f32) -> f32
    
    // Call integer subtraction
    %sub_result = call @sub_int(%arg0, %arg1) : (i32, i32) -> i32
    
    return %xor_result, %add_result, %sub_result : i32, f32, i32
  }
}