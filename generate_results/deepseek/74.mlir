module {
  // Include necessary C++ extern C guards
  func.func @extern_c_guards() {
    "emitc.verbatim"() {value = "#ifdef __cplusplus\nextern \"C\" {\n#endif\n"} : () -> ()
    "emitc.verbatim"() {value = "#ifdef __cplusplus\n}\n#endif\n"} : () -> ()
    return
  }

  // Function to get address of an lvalue
  func.func @get_address(%arg0: !emitc.lvalue<i32>) -> !emitc.ptr<i32> {
    %0 = emitc.apply "&"(%arg0) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>
    return %0 : !emitc.ptr<i32>
  }

  // Function to load value from an lvalue
  func.func @load_value(%arg0: !emitc.lvalue<i32>) -> i32 {
    %1 = emitc.load %arg0 : !emitc.lvalue<i32>
    return %1 : i32
  }

  // Main function demonstrating usage
  func.func @main() -> i32 {
    // First set up C++ extern C guards
    call @extern_c_guards() : () -> ()

    // Create a local variable
    %local_var = "emitc.variable"() {value = 42 : i32} : () -> !emitc.lvalue<i32>

    // Get its address
    %ptr = call @get_address(%local_var) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>

    // Load its value
    %value = call @load_value(%local_var) : (!emitc.lvalue<i32>) -> i32

    // Return the loaded value
    return %value : i32
  }
}