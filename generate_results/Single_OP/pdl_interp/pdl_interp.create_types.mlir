module {
  // Define a PDL Interpreter function named 'create_types_example' with no arguments.
  pdl_interp.func @create_types_example() {
    // Create a handle for a range of constant types (two i64 types)
    %types_handle = pdl_interp.create_types [i64, i64]
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}