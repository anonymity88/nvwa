module {
  // Define a PDL Interpreter function named 'create_attribute_example' with no arguments.
  pdl_interp.func @create_attribute_example() {
    // Create a constant attribute with value 10 of integer type i64.
    %attr = pdl_interp.create_attribute 10 : i64
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}